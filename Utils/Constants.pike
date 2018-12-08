class Constants {
  Gallon websocketPayloads = Gallon(([
    "websocketURI": "wss://gateway.discord.gg/?v=6&encoding=json",

    "identificationPayload": lambda(string token, mapping game, Val.Null|int since, bool afk) {
      return ([
          "op": 2,
          "d": ([
            "token": token,
            "properties": ([
                "$os": "Fisher",
                "$browser": "Fisher",
                "$device": "Fisher",
                "$referrer": "",
                "$referring_domain": ""
              ]),
            "presence": ([
                "game": game,
                  "status": "online",
                  "since": since,
                  "afk": afk
              ]),
            "compress": Val.true,
            "large_threshold": 250,
            "shard": ({0, 1})
            ])
        ]);
      },

  "resumePayload": lambda(string token, string session, int sequence) {
      return ([
        "op": 6,
        "d": ([
          "token": token,
          "session_id": session,
          "seq": sequence
        ])
      ]);
    }

  ]));

  Gallon wsClosingCodes = Gallon(([
    // 4000 is not here because it requires a reconnect
    "4001": "You sent an unknown OP code!\n",
    "4002": "The payload you've sent is!\n",
    "4003": "You've tried to send a payload before identifying!\n",
    "4004": "The token which was provided is wrong!\n",
    "4005": "You sent more than one identify payload!\n",
    // 4006 is not here because it requires a reconnect
    "4008": "You're being ratelimited!\n",
    // 4009 is not here because it requires a reconnect
    "4010": "Invalid shard!",
    "4011": "Shard is required to operate the client since there are too many guilds!"
  ]));

  Gallon permissions_bytes = Gallon(([
      "CREATE_INSTANT_INVITE": 0x00000001,
      "KICK_MEMBERS": 0x00000002,
      "BAN_MEMBERS": 0x00000004,
      "ADMINISTRATOR": 0x00000008,
      "MANAGE_CHANNELS": 0x00000010,
      "MANAGE_GUILD": 0x00000020,
      "ADD_REACTIONS": 0x00000040,
      "VIEW_AUDIT_LOG": 0x00000080,
      "VIEW_CHANNEL": 0x00000400,
      "SEND_MESSAGES": 0x00000800,
      "SEND_TTS_MESSAGES": 0x00001000,
      "MANAGE_MESSAGES": 0x00002000,
      "EMBED_LINKS": 0x00004000,
      "ATTACH_FILES": 0x00008000,
      "READ_MESSAGE_HISTORY": 0x00010000,
      "MENTION_EVERYONE": 0x00020000,
      "USE_EXTERNAL_EMOJIS": 0x00040000,
      "CONNECT": 0x00100000,
      "SPEAK": 0x00200000,
      "MUTE_MEMBERS": 0x00400000,
      "DEAFEN_MEMBERS": 0x00800000,
      "MOVE_MEMBERS": 0x01000000,
      "USE_VAD": 0x02000000,
      "PRIORITY_SPEAKER": 0x00000100,
      "CHANGE_NICKNAME": 0x04000000,
      "MANAGE_NICKNAMES": 0x08000000,
      "MANAGE_ROLES": 0x10000000,
      "MANAGE_WEBHOOKS": 0x20000000,
      "MANAGE_EMOJIS":0x40000000
  ]));
}
