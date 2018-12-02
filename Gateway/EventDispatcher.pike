/*
* Here all the events with OP code 0 will be handled!
* @param {WSHandler} [wsHandler] - The websocket handler
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
}
