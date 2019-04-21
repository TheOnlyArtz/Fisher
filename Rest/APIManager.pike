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
  mapping|array apiRequest(string routeKey,string|Val.Null majorParameter, string method, string endpoint, mapping headers, mapping|array|void|string data, bool|void dataQuery) {
    int retry_after;
    bool requestDone = false;
    string rateLimitKey = majorParameter ? routeKey + majorParameter : routeKey;

    Protocols.HTTP.Query response;

    mapping default_headers = getHeaders();
    Standards.URI uri = Standards.URI(Constants().API->get("URI") + Constants().API->get("VERSION") + endpoint);
    // Standards.URI uri = Standards.URI("https://enobgn68i4wbs.x.pipedream.net");
    while (!requestDone) {
      Thread.Mutex mutex = mutexes[rateLimitKey] ? mutexes[rateLimitKey] : Thread.Mutex();
      mutexWait(mutex);
      // reset the headers
      Thread.MutexKey globalKey = globalMutex->trylock();
      if (globalKey) destruct(globalKey);

      if (dataQuery) {
        if (!headers["Content-Type"])
          headers["Content-Type"] = "application/x-www-form-urlencoded";
          write("==>> %O\n", data);
        response = Protocols.HTTP.do_method(method, uri, data, headers);
      } else {
        if (!headers["Content-Type"])
          headers["Content-Type"] = "application/json";
        else if (headers["Content-Type"] == "multipart/form-data; boundary=main")
          response = Protocols.HTTP.do_method(method, uri, UNDEFINED, headers, UNDEFINED, data);
        else
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
    return has_value(indices(response), "code") && intp(response.code);
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
    string endpoint = sprintf("/channels/%s/messages", channelId);

    additional = additional || ([]);
    mapping payload = ([
      "content": content,
      "nonce": additional["nonce"] || Val.null,
      "tts": additional["tts"] ? true : false,
      "file": additional["file"] ||  Val.null,
      "embed": additional["embed"] || Val.null,
      "payload_json": additional["payload_json"] || ""
    ]);
    mixed requestStr;
    if (payload.file) {
      headers["Content-Type"] = "multipart/form-data; boundary=main";
      // headers["Content-Disposition"] = "";
      requestStr = "\r\n--main\r\nContent-Disposition: form-data; name=\"file\";\r\n\r\n" + payload.file + "\r\n--main--";

      write("%b\n", String.width(requestStr)>8);

      // payload = (["payload_json": (["file": payload.file])])
    }
    mixed resp = apiRequest("channels/id/messages", channelId, "POST", endpoint, headers, requestStr, false);
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

  array(Invite) getChannelInvites(string channelId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/channels/%s/invites", channelId);

    array|void data = apiRequest("channels/id/invites", channelId, "GET", endpoint, headers, UNDEFINED, true);
    array(Invite) invites = ({});

    foreach(data, mapping inviteData) {
      invites = Array.push(invites, Invite(client, inviteData));
    }

    return invites;
  }

  Invite createChannelInvite(string channelId, mapping|void payload) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/channels/%s/invites", channelId);

    payload = payload || ([]);
    mapping|void data = apiRequest("channels/id/invites", channelId, "POST", endpoint, headers, payload, false);

    return Invite(client, data);
  }

  void triggerTypingIndicator(string channelId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/channels/%s/typing", channelId);

    apiRequest("channels/id/typing", channelId, "POST", endpoint, headers, UNDEFINED, false);
  }

  array(Message) getPinnedMessages(string channelId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/channels/%s/pins", channelId);

    array|void data = apiRequest("channels/id/typing", channelId, "GET", endpoint, headers, UNDEFINED, true);
    array(Message) messages = ({});

    foreach(data, mapping msg) {
      messages = Array.push(messages, Message(client, msg));
    }

    return messages;
  }

  void addPinnedChannelMessage(string channelId, string messageId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/channels/%s/pins/%s", channelId, messageId);

    apiRequest("channels/id/pins/id", channelId, "PUT", endpoint, headers, UNDEFINED, false);
  }

  void deletePinnedChannelMessage(string channelId, string messageId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/channels/%s/pins/%s", channelId, messageId);

    apiRequest("channels/id/pins/id", channelId, "DELETE", endpoint, headers, UNDEFINED, false);
  }

  // RENAMED: List Guild Emojis -> Get Guild Emojis
  array(Emoji) getGuildEmojis(string guildId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/emojis", guildId);
    Guild guild = client.guilds->get(guildId);

    // TODO: If guild is not cached, auto fetch it
    array data = apiRequest("guilds/id/emojis", guildId, "GET", endpoint, headers, UNDEFINED, true);
    array(Emoji) emojis = ({});

    foreach(data, mapping emoji) {
      emojis = Array.push(emojis, Emoji(client, guild, emoji));
    }
  }

  Emoji getGuildEmoji(string guildId, string emojiId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/emojis/%s", guildId, emojiId);
    Guild guild = client.guilds->get(guildId);

    // TODO: If guild is not cached, auto fetch it
    mapping data = apiRequest("guilds/id/emojis/id", guildId, "GET", endpoint ,headers, UNDEFINED, true);

    return Emoji(client, guild, data);
  }

  // Note: Fisher won't note the user if the request failed due to file size
  // TODO: support for GIFs and JPEGs
  Emoji createGuildEmoji(string guildId, mapping payload) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/emojis", guildId);
    Guild guild = client.guilds->get(guildId);

    // TODO: If guild is not cached, auto fetch it
    payload["image"] = "data:image/png;base64,"+payload["image"];
    mapping data = apiRequest("guilds/id/emojis", guildId, "POST", endpoint ,headers, payload, false);

    return Emoji(client, guild, data);
  }

  Emoji modifyGuildEmoji(string guildId, string emojiId, mapping payload) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/emojis/%s", guildId, emojiId);
    Guild guild = client.guilds->get(guildId);

    // TODO: If guild is not cached, auto fetch it
    mapping data = apiRequest("guillds/id/emojis/id", guildId, "PATCH", endpoint, headers, payload, false);

    write("%O\n", Emoji(client, guild, data));
    return Emoji(client, guild, data);
  }

  void deleteGuildEmoji(string guildId, string emojiId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/emojis/%s", guildId, emojiId);

    apiRequest("guilds/id/emojis/id", guildId, "POST", endpoint, headers, UNDEFINED, true);
  }

  /** GUILD **/

  //NOTE: Can be used by bots in less than 10 guilds
  Guild createGuild(mapping payload) {
    mapping headers = getHeaders();
    string endpoint = "/guilds";

    payload["verification_level"] = payload["verificationLevel"] || payload["verification_level"];
    payload["default_messages_notifications"] = payload["defaultMessageNotifications"] || payload["default_messages_notifictions"];
    payload["explicit_content_filter"] = payload["explicitContentFilter"] || payload["explicit_content_filter"];

    mapping data = apiRequest("guilds", UNDEFINED, "POST", endpoint, headers, payload, false);

    return Guild(client, data);
  }

  Guild getGuild(string guildId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s", guildId);

    mapping data = apiRequest("guilds/id", UNDEFINED, "GET", endpoint, headers, UNDEFINED, true);
    return Guild(client, data);
  }

  Guild modifyGuild(string guildId, mapping payload) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s", guildId);

    mapping data = apiRequest("guilds/id", guildId, "PATCH", endpoint, headers, payload, false);

    return Guild(client, data);
  }

  void deleteGuild(string guildId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s", guildId);

    apiRequest("guilds/id", guildId, "DELETE", endpoint, headers, UNDEFINED, true);
  }

  array(ChannelVoice|ChannelCategory|GuildTextChannel) getGuildChannels(string guildId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/channels", guildId);
    Guild guild = client.guilds->get(guildId);

    // TODO: If guild is not cached, auto fetch it
    array|mixed data = apiRequest("/guilds/id/channels", guildId, "GET", endpoint, headers, UNDEFINED, true);

    array(ChannelVoice|ChannelCategory|GuildTextChannel) channels = ({});
    foreach(data, mapping data) {
      channels = Array.push(channels, RestUtils()->getChannelAccordingToType(data.type, data, client, guild));
    }

    return channels;
  }

  ChannelVoice|ChannelCategory|GuildTextChannel createGuildChannel(string guildId, mapping payload) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/channels", guildId);
    Guild guild = client.guilds->get(guildId);

    // TODO: Auto fetch using get guild
    if (!payload["name"])
    throw("All parameters are optional excluding [name]");
    else {
      mapping data = apiRequest("/guilds/id/channels", guildId, "POST", endpoint, headers, payload, false);
      return RestUtils()->getChannelAccordingToType(data.type, data, client, guild);
    }
  }

  ChannelVoice|ChannelCategory|GuildTextChannel modifyGuildChannelPosition(string guildId, array payload) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/channels", guildId);

    apiRequest("/guilds/id/channels", guildId, "PATCH", endpoint, headers, payload, false);
  }

  GuildMember getGuildMember(string guildId, string userId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/members/%s", guildId, userId);
    Guild guild = client.guilds->get(guildId);

    // TODO: Auto fetch using get guild
    mapping data = apiRequest("/guilds/id/members/id", guildId, "GET", endpoint, headers, UNDEFINED, true);

    return GuildMember(client, guild, data);
  }

  array(GuildMember) getGuildMembers(string guildId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/members/", guildId);
    Guild guild = client.guilds->get(guildId);

    // TODO: Auto fetch using get guild
    array data = apiRequest("/guilds/id/members", guildId, "GET", endpoint, headers, UNDEFINED, true);
    array(GuildMember) members = ({});

    foreach(data, mapping member) {
      members = Array.push(data, GuildMember(client, guild, member));
    }

    return members;
  }

  void modifyGuildMember(string guildId, string userId, mapping payload) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/members/%s", guildId, userId);

    apiRequest("/guilds/id/members/id", guildId, "PATCH", endpoint, headers, payload, false);
  }

  void modifyCurrentUserNick(string guildId, mapping payload) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/members/@me/nick", guildId);

    apiRequest("/guilds/id/members/@me/nick", guildId, "PATCH", endpoint, headers, payload, false);
  }

  void addGuildMemberRole(string guildId, string userId, string roleId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/members/%s/roles/%s", guildId, userId, roleId);

    apiRequest("/guilds/id/members/id/roles/id", guildId, "PUT", endpoint, headers, UNDEFINED, false);
  }

  void deleteGuildMemberRole(string guildId, string userId, string roleId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/members/%s/roles/%s", guildId, userId, roleId);

    apiRequest("/guilds/id/members/id/roles/id", guildId, "DELETE", endpoint, headers, UNDEFINED, true);
  }

  void removeGuildMember(string guildId, string userId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/members/%s", guildId, userId);

    apiRequest("/guilds/id/members/id", guildId, "DELETE", endpoint, headers, UNDEFINED, true);
  }

  array(mapping) getGuildBans(string guildId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/bans", guildId);

    array(mapping) data = apiRequest("/guilds/id/bans", guildId, "GET", endpoint, headers, UNDEFINED, true);

    if (data) return data;
  }

  mapping getGuildBan(string guildId, string userId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/bans/%s", guildId, userId);

    mapping data = apiRequest("/guilds/id/bans/id", guildId, "GET", endpoint, headers, UNDEFINED, true);

    return data;
  }

  void createGuildBan(string guildId, string userId, mapping|void payload) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/bans/%s", guildId, userId);

    apiRequest("/guilds/id/bans/id", guildId, "PUT", endpoint, headers, payload || ([]), false);
  }

  void removeGuildBan(string guildId, string userId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/bans/%s", guildId, userId);

    apiRequest("/guilds/id/bans/id", guildId, "DELETE", endpoint, headers, UNDEFINED, true);
  }

  array(Role) getGuildRoles(string guildId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/roles", guildId);
    Guild guild = client.guilds->get(guildId);

    // TODO: Auto fetch using get guild
    array data = apiRequest("/guilds/id/roles", guildId, "GET", endpoint, headers, UNDEFINED, true);

    array(Role) roles = ({});
    foreach(data, mapping role) {
      roles = Array.push(roles, Role(client, guild, role));
    }
  }

  Role getGuildRole(string guildId, string roleId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/roles/%s", guildId, roleId);
    Guild guild = client.guilds->get(guildId);

    mapping data = apiRequest("/guilds/id/roles/id", guildId, "GET", endpoint, headers, UNDEFINED, true);

    return Role(client, guild, data);
  }

  void modifyGuildRolePositions(string guildId, array payload) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/roles", guildId);

    apiRequest("/guilds/id/roles/id", guildId, "PATCH", endpoint, headers, payload, false);
  }

  Role modifyGuildRole(string guildId, string userId, mapping payload) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/roles/%s", guildId, userId);
    Guild guild = client.guilds->get(guildId);

    mapping data = apiRequest("/guilds/id/roles/id", guildId, "PATCH", endpoint, headers, payload, false);

    return Role(client, guild, data);
  }

  void deleteGuildRole(string guildId, string userId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/roles/%s", guildId, userId);

    apiRequest("/guilds/id/roles/id", guildId, "DELETE", endpoint, headers, UNDEFINED, true);
  }

  int getGuildPruneCount(string guildId, int|string days) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/prune", guildId);
    days = (string) days;
    mapping data = apiRequest("/guilds/id/prune", guildId, "GET", endpoint, headers, (["days": days]), true);

    return data["pruned"];
  }

  int beginGuildPrune(string guildId, mapping payload) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/prune", guildId);

    mapping data = apiRequest("/guilds/id/prune", guildId, "POST", endpoint, headers, payload, false);

    if (data["pruned"]) data["pruned"];
  }

  array(RegionVoice) getGuildVoiceRegions(string guildId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/regions", guildId);
    Guild guild = client.guilds->get(guildId);

    array data = apiRequest("/guilds/id/region", guildId, "GET", endpoint, headers, UNDEFINED, true);
    array(RegionVoice) regions = ({});

    foreach(data, mapping region) {
      regions = Array.push(regions, RegionVoice(client, guild, region));
    }

    return regions;
  }

  array(Invite) getGuildInvites(string guildId) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/guilds/%s/invites", guildId);

    array data = apiRequest("/guilds/id/invites", guildId, "GET", endpoint, headers, UNDEFINED, true);
    array(Invite) invites = ({});

    foreach(data, mapping invite) {
      invites = Array.push(invites, Invite(client, invite));
    }

    return invites;
  }
  
  Invite getInvite(string inviteCode) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/invites/%s", inviteCode);

    mixed data = apiRequest("invites/code", UNDEFINED, "GET", endpoint, headers, UNDEFINED, true);

    return Invite(client, data);
  }

  void deleteInvite(string inviteCode) {
    mapping headers = getHeaders();
    string endpoint = sprintf("/invites/%s", inviteCode);

    apiRequest("invites/code", UNDEFINED, "DELETE", endpoint, headers, UNDEFINED, true);
  }
}
