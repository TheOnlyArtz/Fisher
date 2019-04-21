class APIManager {
  inherit RestUtils;
  /*
    <Rate limit properties here>
  */
  Protocols.HTTP.Session HTTPSession;

  protected Thread.Mutex globalMutex;
  protected mapping mutexes;
  protected Client client;

  void create(Client c) {
    mutexes = ([]);
    globalMutex = Thread.Mutex();
    client = c;
  }

  // majorParam -> ID
  mapping apiRequest(string routeKey,string|Val.Null majorParameter, string method, string endpoint, mapping headers, mapping|array|void|string data, bool|void dataQuery) {
    int retry_after;
    bool requestDone = false;
    string rateLimitKey = majorParameter ? routeKey + majorParameter : routeKey;

    Protocols.HTTP.Query response;

    mapping default_headers = getHeaders();
    Standards.URI uri = Standards.URI(Constants().API->get("URI") + Constants().API->get("VERSION") + endpoint);
    // Standards.URI uri = Standards.URI("https://enlzy7mj1x8c9.x.pipedream.net/");
    while (!requestDone) {
      Thread.Mutex mutex = mutexes[rateLimitKey] ? mutexes[rateLimitKey] : Thread.Mutex();
      mutexWait(mutex);
      // reset the headers
      Thread.MutexKey globalKey = globalMutex->trylock();
      if (globalKey) destruct(globalKey);

      if (dataQuery) {
        headers["Content-Type"] = "application/x-www-form-urlencoded";
        response = Protocols.HTTP.do_method(method, uri, data, headers);
      } else {
        headers["Content-Type"] = "application/json";
        response = Protocols.HTTP.do_method(method, uri, UNDEFINED, headers, UNDEFINED, Standards.JSON.encode(data));
      }

      if ((int) response.status == 429 || (int) response.headers["x-ratelimit-remaining"] == 0) {
        // We got rate limited
        if (response.headers["retry-after"]) {
          retry_after = response.headers["x-retry_after"];
        } else {
          int originTime = Calendar.ISO.dwim_time(response.headers["date"])->unix_time();
          int resetTime = (int) response.headers["x-ratelimit-reset"];
          retry_after = resetTime - originTime;
        }

       if (response.headers["x-ratelimit-global"]) {
         Thread.MutexKey key = globalMutex->lock();
         call_out(destruct, retry_after, key);
       } else {
         Thread.MutexKey key = mutex->lock();
         call_out(destruct, retry_after, key);
       }
       requestDone = (int) response.status == 429 ? false : true;
     } else {
       requestDone = true;
     }
    }

    if (response.status != 204) {
      mapping parsedData = Standards.JSON.decode(response->data());
      if (hasError(parsedData)) {
        return throw(({"ERROR: " + parsedData.message}));
      }
      return parsedData;
    }
    return UNDEFINED;
  }

  mixed mutexWait(Thread.Mutex mut) {
    Thread.MutexKey key = mut->lock();
    destruct(key);
  }

  mapping getHeaders() {
    return Constants().API->get("headers")(client);
  }

  bool hasError(mixed|void response) {
    return has_value(indices(response), "code");
  }

  /* CHANNEL */

  mixed getChannel(string id) {
    mixed resp = apiRequest("channels/id", id, "GET", "/channels/"+id, getHeaders());
    if (resp.code) return resp;

    return getChannelAccordingToType(resp.type, resp, client);
  }

  mixed modifyChannel(string id, mapping payload) {
    mapping headers = getHeaders();
    mixed resp = apiRequest("channels/id", id, "PATCH", "/channels/"+id, headers, payload, false);
    if ((arrayp(resp.code) && resp[0].code) || resp.code) return resp;

    return getChannelAccordingToType(resp.type, resp, client);
  }

  mixed deleteChannel(string id) {
    mapping headers = getHeaders();
    mixed resp = apiRequest("channels/id", id, "DELETE", "/channels/"+id, headers, UNDEFINED, false);
    if (resp.code) return resp;

    return getChannelAccordingToType(resp.type, resp, client);
  }

  array(Message)|void getChannelMessages(string id, mapping payload) {
    mapping headers = getHeaders();
    mixed resp = apiRequest("channels/id/messages", id, "GET", "/channels/"+id+"/messages", headers, payload, true);
    if (resp[0].code) return;
    if (mappingp(resp)) return throw(({sprintf("ERROR: %O", resp)}));
    array messages = ({});
    foreach(resp, mapping key) {
      messages = Array.push(messages, Message(client, key));
    }
    return messages;
  }

  Message|void getChannelMessage(string channelId, string msgId) {
    mapping headers = getHeaders();
    mixed resp = apiRequest("channels/id/messages", channelId, "GET", "/channels/"+channelId+"/messages/"+msgId, headers, UNDEFINED, true);
    if (resp.code) return;

    return Message(client, resp);
  }

  /* TODO: => https://github.com/pikelang/Pike/issues/33 */
  Message|void createMessage(string channelId, string content, mapping|void additional) {
    mapping headers = getHeaders();
    additional = additional || ([]);
    mapping payload = ([
      "content": content,
      "nonce": additional["nonce"] || 0,
      "tts": additional["tts"] ? true : false,
      "file": additional["file"] ||  0,
      "embed": additional["embed"] || 0,
      "payload_json": additional["payload_json"] || ""
    ]);
    mixed resp = apiRequest("channels/id/messages", channelId, "POST", "/channels/"+channelId+"/messages", headers, payload);
  }

  void createReaction(string channelId, string messageId, string|Emoji emoji) {
    mapping headers = getHeaders();
    headers["Content-Length"] = "0";
    string endpoint = "";
    if (objectp(emoji))
      endpoint = sprintf("/channels/%s/messages/%s/reactions/%s:%s/@me", channelId, messageId, emoji.name, emoji.id);
    else
      endpoint = sprintf("/channels/%s/messages/%s/reactions/%s/@me", channelId, messageId, emoji);

    apiRequest("channels/id/messages/id/reactions/emoji/me", channelId, "PUT", endpoint, headers, UNDEFINED, true);
  }

  void deleteOwnReaction(string channelId, string messageId, string|Emoji emoji) {
    mapping headers = getHeaders();
    headers["Content-Length"] = "0";
    string endpoint = "";
    if (objectp(emoji))
      endpoint = sprintf("/channels/%s/messages/%s/reactions/%s:%s/@me", channelId, messageId, emoji.name, emoji.id);
    else
      endpoint = sprintf("/channels/%s/messages/%s/reactions/%s/@me", channelId, messageId, emoji);

    apiRequest("channels/id/messages/id/reactions/emoji/me", channelId, "DELETE", endpoint, headers, UNDEFINED, true);
  }

  void deleteUserReaction(string channelId, string messageId, string userId, string|Emoji emoji) {
    mapping headers = getHeaders();
    headers["Content-Length"] = "0";
    string endpoint = "";
    if (objectp(emoji))
      endpoint = sprintf("/channels/%s/messages/%s/reactions/%s:%s/%s", channelId, messageId, emoji.name, emoji.id, userId);
    else
      endpoint = sprintf("/channels/%s/messages/%s/reactions/%s/%s", channelId, messageId, emoji, userId);

    apiRequest("channels/id/messages/id/reactions/emoji", channelId, "DELETE", endpoint, headers, UNDEFINED, true);
  }

  array(User|void) getReactions(string channelId, string messageId, Emoji|string emoji, mapping|void payload) {
    mapping headers = getHeaders();
    string endpoint = "";

    if (objectp(emoji))
      endpoint = sprintf("/channels/%s/messages/%s/reactions/%s:%s/", channelId, messageId, emoji.name, emoji.id);
    else
      endpoint = sprintf("/channels/%s/messages/%s/reactions/%s", channelId, messageId, emoji);

    mixed resp = apiRequest("channels/id/messages/id/reactions/id", channelId, "GET", endpoint, headers, payload, true);

    array(User) arr = ({});
    foreach(resp, mapping data) {
      arr = Array.push(arr, User(client, data));
    }

    return arr;
  }

  void deleteAllReactions(string channelId, string messageId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/channels/%s/messages/%s/reactions", channelId, messageId);

    apiRequest("channels/id/messages/id/reactions", channelId, "DELETE", endpoint, headers, UNDEFINED, true);
  }

  Message|void editMessage(string channelId, string messageId, mapping payload) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/channels/%s/messages/%s", channelId, messageId);

    mixed resp = apiRequest("channels/id/messages/id", channelId, "PATCH", endpoint, headers, payload, false);
    if (resp.code) return resp;

    return Message(client, resp);
  }

  void deleteMessage(string channelId, string messageId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/channels/%s/messages/%s", channelId, messageId);

    apiRequest("channels/id/messages/id", channelId, "DELETE", endpoint, headers, UNDEFINED, true);
  }

  void bulkDeleteMessages(string channelId, int amount) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/channels/%s/messages/bulk-delete", channelId);
    string amountS = (string) amount;
    array(Message) snowflakes = getChannelMessages(channelId, (["limit": amountS]));

    apiRequest("channels/id/messages/bulk-delete", channelId, "POST", endpoint, headers,(["messages": snowflakes.id]), false);
  }
  /* TODO!!! completely broken for now */
  void editChannelPermissions(string channelId, string|Role|GuildMember roleOrMember, mapping payload) {
    mapping headers = getHeaders();
    string endpoint = "";
    mixed channel = client.channels->get(channelId);
    // if (!channel)
      //TODO auto fetch with getChannel
    Permission existingOverwrites = Permission(client, ([]), UNDEFINED);
    existingOverwrites = channel.permissionOverwrites->get(objectp(roleOrMember) ? roleOrMember.id : roleOrMember);
    write("%O", channel.permissionOverwrites);
    payload = ([
      "allow": payload.allow || existingOverwrites.allow,
      "deny": payload.deny || existingOverwrites.deny,
      "type": existingOverwrites.type,
      "id": existingOverwrites.id
    ]);

    if (objectp(roleOrMember))
      endpoint = sprintf("/channels/%s/permissions/%s", channelId, roleOrMember.id);
    else
      endpoint = sprintf("/channels/%s/permissions/%s", channelId, roleOrMember);

    apiRequest("channels/id/permissions/id", channelId, "PUT", endpoint, headers, payload, false);
  }
}
