class Reaction {
  int count;
  bool me;
  Emoji emoji;

  protected Client client;

  void create(Client c, mapping data) {
    client = c;
    count = data.count;
    me = data.me;
    emoji = Emoji(data.emoji);
  }
}
