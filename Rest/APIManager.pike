class APIManager {
  /*
    <Rate limit properties here>
  */
  Protocols.HTTP.Session HTTPSession;

  protected Thread.Mutex globalMutex;
  protected mapping mutexes;
  protected Client client;
  protected RateLimiter rateLimiter;
  protected mapping default_headers;
  void create(Client c) {
    mutexes = ([]);
    globalMutex = Thread.Mutex();
    client = c;
    rateLimiter = RateLimiter(c, globalMutex);
    default_headers = ([]);
  }

  // majorParam -> ID
  mixed apiRequest(string routeKey,string|Val.Null majorParameter, string method, string endpoint, mapping headers, mapping data) {
    int retry_after;
    bool requestDone = false;
    string rateLimitKey = majorParameter ? routeKey + majorParameter : routeKey;

    Protocols.HTTP.Query response;

    resetHeaders();
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

    return response;
  }

  mixed mutexWait(Thread.Mutex mut) {
    Thread.MutexKey key = mut->lock();
    destruct(key);
  }
  void resetHeaders() {
    default_headers = Constants().API->get("headers")(client);
  }
}
