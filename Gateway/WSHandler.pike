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
        case 7:
          gatewayDispatcher->handleReconnectionRequest();
          break;
        case 9:
          gatewayDispatcher->handleInvalidSessionEvent();
          break;
        case 10:
          gatewayDispatcher->handleHelloEvent(data);
          break;
        case 11:
          gatewayDispatcher->handleHBackEvent();
          break;
      }

    } else {
      switch(a.t) {
        // case "MESSAGE_CREATE":
        //   write("%O", data);
        //   break;
        case "READY":
          eventDispatcher->handleReadyEvent(data);
          break;
        case "GUILD_CREATE":
          eventDispatcher->handleGuildCreateEvent(data);
          break;
        case "GUILD_UPDATE":
          eventDispatcher->handleGuildUpdateEvent(data);
          break;
        case "GUILD_BAN_ADD":
          eventDispatcher->handleGuildBanAddEvent(data);
          break;
        case "GUILD_BAN_REMOVE":
          eventDispatcher->handleGuildBanRemoveEvent(data);
          break;
        case "GUILD_EMOJIS_UPDATE":
          eventDispatcher->handleGuildEmojisUpdateEvent(data);
          break;
        case "GUILD_MEMBER_ADD":
          eventDispatcher->handleGuildMemberAdd(data);
          break;
      }
    }
  }
}
