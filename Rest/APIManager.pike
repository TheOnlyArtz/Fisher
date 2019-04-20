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
  mapping apiRequest(string routeKey,string|Val.Null majorParameter, string method, string endpoint, mapping headers, mapping|void data) {
    int retry_after;
    bool requestDone = false;
    string rateLimitKey = majorParameter ? routeKey + majorParameter : routeKey;

    Protocols.HTTP.Query response;

    mapping default_headers = getHeaders();
    Standards.URI uri = Standards.URI(Constants().API->get("URI") + Constants().API->get("VERSION") + endpoint);

    while (!requestDone) {
      Thread.Mutex mutex = mutexes[rateLimitKey] ? mutexes[rateLimitKey] : Thread.Mutex();
      mutexWait(mutex);
      // reset the headers
      Thread.MutexKey globalKey = globalMutex->trylock();
      if (globalKey) destruct(globalKey);

      response = Protocols.HTTP.do_method(method, uri, data, headers);

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

    mapping parsedData = Standards.JSON.decode(response->data());
    if (hasError(parsedData)) {
      return throw(({"ERROR: " + parsedData.message}));
    }
    return parsedData;
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
    headers["Content-Type"] = "application/json";
    mixed resp = apiRequest("channels/id", id, "PATCH", "/channels/"+id, headers, payload);
    if (resp.code) return resp;

    return getChannelAccordingToType(resp.type, resp, client);
  }

  mixed deleteChannel(string id) {
    mapping headers = getHeaders();
    mixed resp = apiRequest("channels/id", id, "DELETE", "/channels/"+id, headers);
    if (resp.code) return resp;

    return getChannelAccordingToType(resp.type, resp, client);
  }

  array(Message)|void getChannelMessages(string id, mapping payload) {
    mapping headers = getHeaders();
    mixed resp = apiRequest("channels/id/messages", id, "GET", "/channels/"+id+"/messages", headers, payload);
    if (resp.code) return;
    if (mappingp(resp)) return throw(({sprintf("ERROR: %O", resp)}));
    array messages = ({});
    foreach(resp, mapping key) {
      messages = Array.push(messages, Message(client, key));
    }

    return messages;
  }

  Message|void getChannelMessage(string channelId, string msgId) {
    mapping headers = getHeaders();
    mixed resp = apiRequest("channels/id/messages", channelId, "GET", "/channels/"+channelId+"/messages/"+msgId, headers);
    if (resp.code) return;

    return Message(client, resp);
  }
}
