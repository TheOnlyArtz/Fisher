class WSHandler {
  mapping opCodes;
  WSManager wsManager;
  int|Val.null sequence;

  void create(WSManager w) {
    wsManager = w;
  }
}
