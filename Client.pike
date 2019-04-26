/*
* Client - The Discord API Client itself
* @param {string} token - The client's token
* @property {WSManager} wsManager - The Websocket Manager
* @property {EventHandlers} handlers - The Client handlers callbacks (for events)
* @property {Protocols.WebSocket.Connection} ws - The Websocket connection object
* Caching utils:
* @property {mapping} users - All of the cached users
* @property {mapping} presences - All of the cached presences
* @property {mapping} guilds - All of the cached guilds
* @property {mapping} channels - All of the cached channels
* Others:
* @property {ClientUser} user - The user of the client (User with more features)
*/
class Client {
  string token;
  inherit EventUtils;
  WSManager wsManager;
  APIManager api;
  Protocols.WebSocket.Connection ws;

  // Caching
  Cache users;
  Cache presences;
  Cache guilds;
  Cache channels;
  Cache emojis;

  mapping options;
  // Others
  ClientUser user;
  ClientCacher cacher;

  TTLCache ttlList;

  /*
  * The constructor
  */
  void create(string t, mapping|void options) {
    options = options || ([]);
    token = t;
    wsManager = WSManager(this);
    api = APIManager(this);
    handlers = EventHandlers();
    // Caching
    if (options.TTLCache == true) {
      ttlList = TTLCache();
    }

    users = Cache(ttlList, "users");
    // presences = Cache(ttlList, "presences"); // TODO
    guilds = Cache(ttlList, "guilds");
    channels = Cache(ttlList, "channels");
    emojis = Cache(ttlList, "emojis");
    cacher = ClientCacher(this);
    eventsClient = this;
  }

  void login() {
    wsManager->start(false, false);
  }
}
