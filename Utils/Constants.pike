class Constants {
  mapping websocketPayloads = ([
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

  ]);

  mapping wsClosingCodes = ([
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
  ]);
}
