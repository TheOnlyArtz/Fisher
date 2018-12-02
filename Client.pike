#include "Gateway/WSManager.pike"

/*
* Client - The Discord API Client itself
* @param {string} token - The client's token
* @property {WSManager} wsManager - The Websocket Manager
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
  WSManager wsManager;
  Protocols.WebSocket.Connection ws;

  // Caching
  mapping users;
  mapping presences;
  mapping guilds;
  mapping channels;

  // Others
  ClientUser user;

  /*
  * The constructor
  */
  void create(string t) {
    token = t;
    wsManager = WSManager(this);

    // Caching
    users = ([]);
    presences = ([]);
    guilds = ([]);
    channels = ([]);

  }

  void login() {
    wsManager->start();
  }
}
