#include "WSHandler.pike"

/*
* WebSocket manager - Managing all of the Websocket traffic.
* @param {Client} client - The client.
* @property {WSHandler} wsHandler - The Websocket handler
* @property {string} wsSessionID - The Websocket session ID
* @property {Protocols.WebSocket.Connection} ws]- The WS connection object
*/
class WSManager {

  Client client;
  WSHandler wsHandler;
  string wsSessionID;
  Protocols.WebSocket.Connection ws;

  /*
  * The constructor
  */
  void create(Client c) {
    client = c;
    wsHandler = WSHandler(this);
  }

  /*
    Used to start the process of connection the bot to the websocket
  */
  void start() {
    ws = connectWS();
    ws->onmessage = onmessage;
    ws->onopen = onopen;
    ws->onclose;
  }

  /*
    Used to establish a websocket connection and return the connection object.
    Returns <Protocols.WebSocket.Connection>
  */
  Protocols.WebSocket.Connection connectWS() {

    // The Websocket/Gateway link for Discord.
    Standards.URI wsLink = Standards.URI("wss://gateway.discord.gg/?v=6&encoding=json");

    // The WS client in this scope.
    Protocols.WebSocket.Connection wsClient = Protocols.WebSocket.Connection();

    // Connect to the WS
    wsClient->connect(wsLink);

    return wsClient;
  }

  /*
  * Dispatches whenever the socket opens.
  * Sends an identification payload to the websocket.
  */
  void onopen() {
    mapping identifyPayload = ([
        "op": 2,
        "d": ([
          "token": client.token,
          "properties": ([
              "$os": "Fisher",
              "$browser": "Fisher",
              "$device": "Fisher",
              "$referrer": "",
              "$referring_domain": ""
            ]),
          "presence": ([
              "game": Val.null,
                "status": "online",
                "since": Val.null,
                "afk": Val.false
            ]),
          "compress": Val.false,
          "large_threshold": 250,
          "shard": ({0, 1})
          ])
      ]);

    string payload = Standards.JSON.encode(identifyPayload);
    ws->send_text(payload);
  }

  /*
  * Dispatches whenever a new packet frame comes from the Websocket.
  * Lets the WSHandler to handle the packets
  */
  void onmessage(Protocols.WebSocket.Frame frame) {
    int anActualJSON = Standards.JSON.validate(frame->data);

    if (anActualJSON) {
      mapping json = Standards.JSON.decode(frame->data);
      wsHandler->handle(json); // TODO: Figure out why it crashes!
    }
  }

  /*
  *  Dispatches whenever the socket closes
  *  And exists the program
  */
  void onclose() {
    write("Socket closed!");
    exit(1);
  }

}
