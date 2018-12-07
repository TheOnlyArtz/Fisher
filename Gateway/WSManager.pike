/**
 * WebSocket manager - Managing all of the Websocket traffic.
 * @param {Client} client - The client.
 * @property {string} wsSessionID - The Websocket session ID
 * @property {int} heartbeat_interval - The heartbeat interval
 * @property {int} curr_heartbeat_time - Updates everytime the client attempts to send a heartbeat
 * @property {int} perv_heartbeat_ack - The most recent (cached) heartbeat ack to compare with the new
 * @property {bool} reconnecting - An indicator of whether or not the client is resuming
 * @property {bool} reconnecting - An indicator of whether or not the client is reconnecting
 * @property {object} constants - A set of important constant values
 * @property {WSHandler} wsHandler - The Websocket handler
 * @property {Protocols.WebSocket.Connection} ws- The WS connection object
 */
class WSManager {

  Client client;
  string wsSessionID;

  int heartbeat_interval;
  int perv_heartbeat_ack;

  protected int curr_heartbeat_time;
  protected bool resuming;
  protected bool reconnecting;

  object constants = Constants();

  int sequence;
  WSHandler wsHandler;

  Protocols.WebSocket.Connection|Val.Null ws;


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
  void start(bool reconnect, bool resume) {
    if (reconnect) {
      ws->close(resume ? 4000 : 1000);

      curr_heartbeat_time = 0;
      perv_heartbeat_ack = 0;
    }

    ws = connectWS(reconnect, resume);
    ws->onmessage = onmessage;
    ws->onopen = onopen;
    ws->onclose = onclose;

}
  /**
   * Used to establish a websocket connection and return the connection object.
   * Returns <Protocols.WebSocket.Connection>
   */
  Protocols.WebSocket.Connection connectWS(bool reconnect, bool resume) {
    resuming = resume;
    reconnecting = reconnect;
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
    mapping payload;

    if (!resuming) {
      payload = constants.websocketPayloads->identificationPayload(client.token, ([]), Val.null, Val.false);
    } else {
      payload = constants.websocketPayloads->resumePayload(client.token, wsSessionID, sequence);
    }

    string jsonPayload = Standards.JSON.encode(payload);
    ws->send_text(jsonPayload);
    resuming = false;
    reconnecting = false;
  }

  /**
   * Dispatches whenever a new packet frame comes from the Websocket.
   * Lets the WSHandler to handle the packets
   */
  void onmessage(Protocols.WebSocket.Frame frame) {
    if (frame.opcode == Protocols.WebSocket.FRAME_TEXT) {
      mapping json = Standards.JSON.decode(frame.data);
      wsHandler->handle(json);
    } else {
      frame.data = handleCompression(frame);
      frame.opcode = Protocols.WebSocket.FRAME_TEXT;
      onmessage(frame);
    }
  }

  /**
  * Handles the compressed data from Discord
  */
  string handleCompression(Protocols.WebSocket.Frame frame) {
    string data = Gz.inflate()->inflate(frame.data);
    return data;
  }

  /**
   *  Dispatches whenever the socket closes
   *  And exists the program
   */
  void onclose(Protocols.WebSocket.CLOSE_STATUS status) {
    if (status == 0 || reconnecting) return;

    // There are status codes which require a reconnection to the socket.
    bool needAReconnect = status == 4000 || status == 4007 || status == 4009;
    if (needAReconnect) {
      start(true, false);
      return;
    }

    string statusString = (string) status;
    string errorMsg = "ERROR: " + constants.wsClosingCodes[statusString];

    throw( ({errorMsg, backtrace()}) );
    return;
  }

  /*
  * Make the client to start heartbeating
  * @param {int} ms - The time for the interval to repeat
  */
  void heartbeat(int ms) {
    if (uslessHBrun == false) {

      if (curr_heartbeat_time > perv_heartbeat_ack) {
        start(true, true);
        call_out(heartbeat, ms, ms);
        return;
      }

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
