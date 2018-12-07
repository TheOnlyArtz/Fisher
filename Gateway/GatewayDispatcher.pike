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

  void handleHBackEvent() {
    wsHandler.wsManager.perv_heartbeat_ack = time();
  }

  void handleInvalidSessionEvent() {
    wsHandler.wsManager->start(true, false);
  }

  void handleReconnectionRequest() {
    wsHandler.wsManager->start(true, true);
  }
}
