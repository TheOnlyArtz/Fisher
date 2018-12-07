class WSHandler {
  Client client;
  WSManager wsManager;
  EventDispatcher eventDispatcher;
  GatewayDispatcher gatewayDispatcher;
  int sequence;

  void create(WSManager w) {
    wsManager = w;
    client = w.client;
    eventDispatcher = EventDispatcher(this);
    gatewayDispatcher = GatewayDispatcher(this);
  }

  void handle(mapping a) {
    int opCode = a.op;
    mapping data = a.d;
    wsManager.sequence = a.s;

    if (opCode != 0) {
      switch(opCode) {
        case 9:
          gatewayDispatcher->handleInvalidSessionEvent();
        case 10:
          gatewayDispatcher->handleHelloEvent(data);
          break;
        case 11:
          gatewayDispatcher->handleHBackEvent();
          break;
      }

    } else {
      switch(a.t) {
        case "READY":
          eventDispatcher->handleReadyEvent(data);
          break;
        case "GUILD_CREATE":
          eventDispatcher->handleGuildCreateEvent(data);
      }
    }
  }
}
