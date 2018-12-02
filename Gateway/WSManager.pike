#include "WSHandler.pike"

/**
 * WebSocket manager - Managing all of the Websocket traffic.
 * @param {Client} client - The client.
 * @property {string} wsSessionID - The Websocket session ID
 * @property {int} heartbeat_interval - The heartbeat interval
 * @property {int} curr_heartbeat_time - Updates everytime the client attempts to send a heartbeat
 * @property {int} perv_heartbeat_ack - The most recent (cached) heartbeat ack to compare with the new one
 * @property {WSHandler} wsHandler - The Websocket handler
 * @property {Protocols.WebSocket.Connection} ws- The WS connection object
 */
class WSManager {

  Client client;
  string wsSessionID;

  int heartbeat_interval;
  int curr_heartbeat_time;
  int perv_heartbeat_ack;

  int sequence;
  WSHandler wsHandler;

  Protocols.WebSocket.Connection ws;


  bool uslessHBrun = true;
  /**
   * The constructor
   */
  void create(Client c) {
    client = c;
    wsHandler = WSHandler(this);

    curr_heartbeat_time = 0;
    perv_heartbeat_ack = 0;
  }

  /**
   * Used to start the process of connection the bot to the websocket
   */
  void start() {
    ws = connectWS();
    ws->onmessage = onmessage;
    ws->onopen = onopen;
    ws->onclose;
  }

  /**
   * Used to establish a websocket connection and return the connection object.
   * Returns <Protocols.WebSocket.Connection>
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

  /**
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

  /**
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

  /**
   *  Dispatches whenever the socket closes
   *  And exists the program
   */
  void onclose() {
    write("Socket closed!");
    exit(1);
  }

  /*
  * Make the client to start heartbeating
  * @param {int} ms - The time for the interval to repeat
  */
  void heartbeat(int ms) {
    if (uslessHBrun == false) {

      // if (curr_heartbeat_time > perv_heartbeat_ack) TODO: Reconnect and RESUME

      mapping mappingPayload = ([
          "op": 1,
          "d": sequence
        ]);

        // Send heartbeat payload
      string payload = Standards.JSON.encode(mappingPayload);
      ws->send_text(payload);

      curr_heartbeat_time = time();
    } else {
      uslessHBrun = false;;
    }

    call_out(heartbeat, ms, ms);
  }
}
