#include "Gateway/WSManager.pike"

/*
* Client - The Discord API Client itself
* @param {string} token - The client's token
* @param {WSManager} [wsManager] - The Websocket Manager
* @param {Protocols.WebSocket.Connection} ws - The Websocket connection object
*/
class Client {
  string token;
  WSManager wsManager;
  Protocols.WebSocket.Connection ws;

  /*
  * The constructor
  */
  void create(string t) {
    token = t;
    wsManager = WSManager(this);
  }
  
  void login() {
    wsManager->start();
  }
}
