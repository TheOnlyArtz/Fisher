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
          eventDispatcher->ready(data);
          break;
        case "GUILD_CREATE":
          eventDispatcher->guildCreate(data);
          break;
        case "GUILD_UPDATE":
          eventDispatcher->guildUpdate(data);
          break;
        case "GUILD_BAN_ADD":
          eventDispatcher->guildBanAdd(data);
          break;
        case "GUILD_BAN_REMOVE":
          eventDispatcher->guildBanRemove(data);
          break;
        case "GUILD_EMOJIS_UPDATE":
          eventDispatcher->guildEmojisUpdate(data);
          break;
        case "GUILD_MEMBER_ADD":
          eventDispatcher->guildMemberAdd(data);
          break;
        case "GUILD_MEMBER_REMOVE":
          eventDispatcher->guildMemberRemove(data);
          break;
        case "GUILD_MEMBER_UPDATE":
          eventDispatcher->guildMemberUpdate(data);
          break;
      }
    }
  }
}
