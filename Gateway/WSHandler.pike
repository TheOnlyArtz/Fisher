class WSHandler {
  WSManager wsManager;
  Client client;
  int sequence;

  void create(WSManager w) {
    wsManager = w;
    client = w.client;
  }

  void handle(mapping packet) {
    write("%O", packet);
  }
}
