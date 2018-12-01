class WSManager {
  Client client;
  Protocols.WebSocket.Connection ws;

  void create(Client c) {
    client = c;
  }

  void start() {
    ws = connectWS();
    ws->onmessage = onmessage;
    ws->onopen = onopen;
    ws->onclose;
  }

  /*
    Used to establish a websocket connection and return the connection object.
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
          "compress": Val.true,
          "large_threshold": 250,
          "shard": ({0, 1})
          ])
      ]);

    string payload = Standards.JSON.encode(identifyPayload);
    ws->send_text(payload);
  }

  void onmessage(Protocols.WebSocket.Frame frame) {

    int anActualJSON = Standards.JSON.validate(frame->data);

    if (anActualJSON) {
      mapping json = Standards.JSON.decode(frame->data);
    }
  }

  void onclose() {
    write("Socket closed!");
  }

}
