class Disposal {
  int ttl;  // In minutes
  int trim; // In minutes
  Gallon cache; // Guilds/Users/Members/Emojis/Roles/Messages/Channels

  void create(int t, int tr, Gallon c) {
    ttl = t;
    trim = tr;
    cache = c;
  }
}
