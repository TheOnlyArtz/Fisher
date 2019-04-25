class Disposal {
  int ttl;  // In seconds
  int trim; // In seconds
  Gallon cache; // Guilds/Users/Members/Emojis/Roles/Messages/Channels
  Gallon entries;

  void create(int t, int tr, Gallon c) {
    ttl = t;
    trim = tr;
    cache = c;
    entries = Gallon(([]));

    startCollecting();
  }

  void startCollecting() {
    collect();
    call_out(startCollecting, trim);
  }

  void addEntry(string key, mixed value) {
    cache->assign(key, value);

    // Add the entry to the entries with time() + ttl
    entries->assign(key, time() + ttl);
  }

  void collect() {
    mixed val;
    foreach(entries->arrayOfKeys(), string key) {
      val = entries->get(key);
      if (val < time()) {
        cache->delete(key);
        entries->delete(key);
      }
    }
  }
}
