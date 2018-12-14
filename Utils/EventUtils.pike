class EventUtils {
  EventHandlers handlers;

  Client eventsClient;

  void handle(string event, function handler) {
    eventsClient.handlers[event] = Array.push(eventsClient.handlers[event], handler);
  }

  void emit(string event, mixed ... data) {
    foreach(eventsClient.handlers[event], function handler) {
      handler(@data);
    }
  }
}
