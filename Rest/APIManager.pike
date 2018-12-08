/**
* The API manager will manage handler to the incoming and outgoing
* HTTP Requests towards the Discord API
*/
class APIManager {
  Client client;
  RateLimiter rateLimiter;
  object constants = Constants();
}
