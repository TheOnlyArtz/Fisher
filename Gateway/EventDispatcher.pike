// MODELS:
/* READY EVENT */
#include "../Models/ClientUser.pike"

/*
* Here all the events with OP code 0 will be handled!
* @property {WSHandler} wsHandler - The websocket handler
* @param {Client} client - The client.
*/
class EventDispatcher {
  WSHandler wsHandler;
  Client client;

  /*
  * The constructor
  */
  void create(WSHandler w) {
    wsHandler = w;
    client = w.client;
  }

  /*
  * handles the READY event
  * @param data
  */
  void handleReadyEvent(mapping data) {
    client.user = ClientUser(data.user);
    wsHandler.wsManager.wsSessionID = data.session_id;

    // Emit the event
  }
}
