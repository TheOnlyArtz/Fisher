#include "EventDispatcher.pike"

class WSHandler {
  Client client;
  WSManager wsManager;
  EventDispatcher dispatcher;
  int sequence;

  void create(WSManager w) {
    wsManager = w;
    client = w.client;
    dispatcher = EventDispatcher(this);
  }

  void handle(mapping a) {
    int opCode = a.op;
    mapping data = a.d;
    if (opCode != 0) return;

    switch(a.t) {
      case "READY":
        dispatcher->handleReadyEvent(data);
        break;
      case "GUILD_CREATE":
        dispatcher->handleGuildCreateEvent(data);
    }
  }
}
