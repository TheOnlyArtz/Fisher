class Constants {
  mapping websocket = ([
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
            "compress": false,
            "large_threshold": 250,
            "shard": ({0, 1})
            ])
        ]);
      }

    "resumePayload": lambda(string token, string session, int sequence) {
      return ([
        "op": 6,
        "d": ([
          "token": token,
          "session_id": session,
          "seq", sequence
        ])
      ]);
    }


    
  ]);

}
