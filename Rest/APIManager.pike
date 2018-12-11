/**
* The API manager will manage handler to the incoming and outgoing
* HTTP Requests towards the Discord API
*/
class APIManager {
  Client client;
  RateLimiter rateLimiter;
  object constants = Constants();
  string API_URI = constants.API->get("URI") + constants.API->get("VERSION");

  void create(Client c) {
    client = c;
    rateLimiter = RateLimiter(this);
  }

  mixed request(string method, string endpoint, string route, mapping data, mapping files) {
    if (!rateLimiter.queue[route]) {
      rateLimiter.queue[route] = (["queue": ({})]);
    }
    rateLimiter.queue[route]["queue"] = Array.push(rateLimiter.queue[route]["queue"], (["method":method, "endpoint":endpoint, "route":route, "data":data, "files":files]));
    write("%O", rateLimiter.queue[route]);
    rateLimiter->operateQueue(route);
  }

  Protocols.HTTP.Query APIRequest(string method, string endpoint, string route, mapping data, mapping files) {
    Standards.URI uri = Standards.URI(API_URI + endpoint);
    Protocols.HTTP.Query q = Protocols.HTTP[lower_case(method) + "_url"](uri, data, constants.API->get("headers")(client));

    return q;
  }
}
