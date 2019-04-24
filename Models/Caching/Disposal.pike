class Disposal {
  int ttl;  // In seconds
  int trim; // In seconds
  Gallon cache; // Guilds/Users/Members/Emojis/Roles/Messages/Channels

  void create(int t, int tr, Gallon c) {
    ttl = t;
    trim = tr;
    cache = c;
  }
}
