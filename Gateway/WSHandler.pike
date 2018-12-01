class WSHandler {
  WSManager wsManager;
  Client client;
  int|Val.null sequence;

  void create(WSManager w) {
    wsManager = w;
    client = w.client;
  }

  void handle() {
    
  }
}
