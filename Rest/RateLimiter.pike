/**
* The RateLimiter will handle all of the rate limiting related
* traffic in order to not get those 429s
*/
class RateLimiter {
  object constants = Constants();

  mapping limitHeaders;

  bool resetTimer;

  mapping queue = ([]);

  APIManager apiManager;
  void create(APIManager a) {
    apiManager = a;
    resetTimer = false;
  }

  /**
  * Whether a request can fire!
  * Returns 0 if not (So the request will get pushed to queue)
  * Returns 1 if it's safe
  */
  int isSafe(string method, string endpoint, mapping data, mapping options, mapping files) {
    int currentTime = time();

    if (currentTime < limitHeaders["Reset"] || limitHeaders["Remaining"] < 1) {
      return 0;
    }

    return 1;
  }

  // Returns 1 if the queue loop should stop
  mixed|void operateQueue(string route) {
    mapping routeQueue = queue[route];
    array reqQueue = routeQueue["queue"];
    bool toLimit = false;
    if (routeQueue["RESET-RATELIMIT"]) {
      return ([]);
    }
    mapping initialParameter = reqQueue[0];

    Protocols.HTTP.Query response = apiManager->APIRequest(
     initialParameter["method"],
     initialParameter["endpoint"],
     initialParameter["route"],
     initialParameter["data"],
     initialParameter["files"]
   );

    routeQueue["queue"] = Array.shift(routeQueue["queue"])[1];

    mapping headers = response.headers;
    string remainingHeader = headers["x-ratelimit-remaining"];
    int resetHeader = (int) headers["x-ratelimit-reset"];

    write("%O", response.status);
    if (resetHeader && remainingHeader == "0") {
      routeQueue["RESET-RATELIMIT"] = resetHeader - Calendar.ISO.dwim_time(headers.date)->unix_time();
      toLimit = true;
    }

    if (response.status < 300) {
      if (toLimit) {
        call_out(unlockQueue, routeQueue["RESET-RATELIMIT"], route);
        toLimit = false;
      }
      return (["data": response.data, "limit": toLimit]);
    }

    // TODO 429. 502
  }

  void unlockQueue(string route) {
    mapping routeQueue = queue[route];

    routeQueue["RESET-RATELIMIT"] = false;
    int keepLooping;

    for(int i = 0; i < sizeof(routeQueue["queue"]); i++) {
      keepLooping = operateQueue(route);
      if (keepLooping["limit"]) break;
    }
  }
}
