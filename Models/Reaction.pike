class Reaction {
  int count;
  bool me;
  ReactionEmoji emoji;
  User|string user;
  Message message;
  protected Client client;

  // emote is basically emoji... just so conflicts won't happen.
  void create(Client c, Message msg, mapping data) {
    client = c;
    count = data.count || 0;
    me = data.me;
    message = msg;
    emoji = ReactionEmoji(c, this, data.emoji);
    user = c.users->get(data.user_id);

    if (!user)
      user = data.user_id;
  }
}
