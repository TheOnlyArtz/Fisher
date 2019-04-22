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
        case "READY":
          eventDispatcher->ready(data);
          break;
        case "GUILD_CREATE":
          eventDispatcher->guildCreate(data);
          break;
        case "CHANNEL_CREATE":
          eventDispatcher->channelCreate(data);
          break;
        case "CHANNEL_UPDATE":
          eventDispatcher->channelUpdate(data);
          break;
        case "CHANNEL_DELETE":
          eventDispatcher->channelDelete(data);
          break;
        case "CHANNEL_PINS_UPDATE":
          eventDispatcher->channelPinsUpdate(data);
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
        case "GUILD_INTEGRATION_UPDATE":
          eventDispatcher->guildIntegrationUpdate(data);
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
        case "GUILD_ROLE_CREATE":
          eventDispatcher->guildRoleCreate(data);
          break;
        case "GUILD_ROLE_UPDATE":
          eventDispatcher->guildRoleUpdate(data);
          break;
        case "GUILD_ROLE_DELETE":
          eventDispatcher->guildRoleDelete(data);
          break;
        case "MESSAGE_CREATE":
          eventDispatcher->messageCreate(data);
          break;
        case "MESSAGE_UPDATE":
          eventDispatcher->messageUpdate(data);
          break;
        case "MESSAGE_DELETE":
          eventDispatcher->messageDelete(data);
          break;
        case "MESSAGE_DELETE_BULK":
          eventDispatcher->messageDeleteBulk(data);
          break;
        case "MESSAGE_REACTION_ADD":
          eventDispatcher->messageReactionAdd(data);
          break;
        case "MESSAGE_REACTION_REMOVE":
          eventDispatcher->messageReactionRemove(data);
          break;
        case "MESSAGE_REACTION_REMOVE_ALL":
          eventDispatcher->messageReactionRemoveAll(data);
          break;
        case "PRESENCE_UPDATE":
          eventDispatcher->presenceUpdate(data);
          break;
        case "TYPING_START":
          eventDispatcher->typingStart(data);
          break;
        case "USER_UPDATE":
          eventDispatcher->userUpdate(data);
          break;
      }
    }
  }
}
