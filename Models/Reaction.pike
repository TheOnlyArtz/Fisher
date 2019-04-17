class Reaction {
  int count;
  bool me;
  ReactionEmoji emoji;

  protected Client client;

  // emote is basically emoji... just so conflicts won't happen.
  void create(Client c, mapping data) {
    client = c;
    count = data.count;
    me = data.me;
    emoji = ReactionEmoji(c, this, data);
  }
}
