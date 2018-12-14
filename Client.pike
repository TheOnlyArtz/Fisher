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

  Protocols.WebSocket.Connection ws;

  // Caching
  Gallon users;
  Gallon presences;
  Gallon guilds;
  Gallon channels;
  Gallon emojis;

  mapping options;
  // Others
  ClientUser user;
  ClientCaching cacher;

  /*
  * The constructor
  */
  void create(string t, mapping|void options) {
    token = t;
    wsManager = WSManager(this);
    handlers = EventHandlers();
    // Caching
    users = Gallon(([]));
    presences = Gallon(([]));
    guilds = Gallon(([]));
    channels = Gallon(([]));
    emojis = Gallon(([]));

    cacher = ClientCaching(this);
    eventsClient = this;
  }

  void login() {
    wsManager->start(false, false);
  }
}
