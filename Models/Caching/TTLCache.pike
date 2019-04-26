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
    call_out(dispose, 5 * 60);
  }

  void loopTTLlist(Gallon list) {
    mixed val;
    array(string) keys = list->arrayOfKeys();

    foreach(keys, string key) {
      if (key == "cacheObject") continue;
      val = list->get(key);
      if (basetype(val) == "string") {
        if (val < time()) {
          list.cache->delete(key);
        }
      } else {
        if (val->get("expires") < time()) {
          list.cache->delete(key);
        }
      }
    }
  }
}
