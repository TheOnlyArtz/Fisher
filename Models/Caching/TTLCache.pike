class TTLCache {

  Gallon guildsTTL;
  Gallon channelsTTL;
  Gallon emojisTTL;
  Gallon rolesTTL;
  Gallon usersTTL;
  Gallon messagesTTL;
  Gallon membersTTL;
  Gallon presencesTTL;

  void create() {
    guildsTTL = Gallon(([]));
    channelsTTL = Gallon(([]));
    emojisTTL = Gallon(([]));
    rolesTTL = Gallon(([]));
    messagesTTL = Gallon(([]));
    usersTTL = Gallon(([]));
    membersTTL = Gallon(([]));
    presencesTTL = Gallon(([]));

    Thread.Thread(dispose); // Run TTL on a separate since it may cause blocks
  }

  // Trim default is 5 minutes
  void dispose() {
    loopTTLlist(guildsTTL);
    loopTTLlist(channelsTTL);
    loopTTLlist(emojisTTL);
    loopTTLlist(rolesTTL);
    loopTTLlist(usersTTL);
    loopTTLlist(messagesTTL);
    loopTTLlist(membersTTL);
    loopTTLlist(presencesTTL);
    call_out(Thread.Thread, 5, dispose);
    Thread.this_thread()->kill();
  }

  void loopTTLlist(Gallon list) {
    mixed val;
    array(string) keys = list->arrayOfKeys();
    if (!sizeof(keys)) return;

    foreach(keys, string key) {
      if (key == "cachedObject") continue;
      val = list->get(key);
      if (basetype(val) == "string") {
        if (val < time()) {
          list->get("cachedObject")->delete(key);
          list->delete(key);
        }
      } else {
        if (val["expires"] < time()) {
          list->get("cachedObject")->delete(key);
          list->delete(key);
        }
      }
    }
  }
}
