/**
* Used to dispatch gateway events OP Codes (1 - 11)
* @property {WSHandler} wsHandler - The websocket handler
* @param {Client} client - The client.
*/

class GatewayDispatcher {
  WSHandler wsHandler;
  Client client;

  /**
  * The constructor
  */
  void create(WSHandler w) {
    wsHandler = w;
    client = w.client;
  }

  void handleHelloEvent(mapping data) {
    wsHandler.wsManager.heartbeat_interval = data.heartbeat_interval;
  }
}
