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
  mapping|void apiRequest(string routeKey,string|Val.Null majorParameter, string method, string endpoint, mapping headers, mapping data) {
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

      response = Protocols.HTTP[lower_case(method) + "_url"](uri, data, default_headers);

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
    if (parsedData.code) {
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

  /* CHANNEL */

  mapping getChannel(string id) {
    mixed resp = apiRequest("channels/id", id, "GET", "/channels/"+id, getHeaders(), ([]));
    if (resp.code) return resp;

    return getChannelAccordingToType(resp.type, resp);
  }
}
