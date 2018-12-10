class Message {
  string id;
  GuildChannel channel;// TO DO TEXTCHANNEL
  Guild guild;
  User author;
  GuildMember member;
  string content;
  string timestamp;
  string|Val.Null edited_timestamp;
  bool tts;
  bool mention_everyone;

  Gallon mentions; // EVERYONE, USERS, ROLES
  Gallon attachments;
  Gallon embeds;
  Gallon reactions;

  string|Val.Null nonce;
  bool pinned;
  string webhook_id;
  int type;

  /**
  * TODO:
  * Look at: message.activity and message.application
  * See: https://discordapp.com/developers/docs/resources/channel#message-object
  **/

  void create(Client client, mapping data) {
    id = data.id;
    // channel = ; TODO!!!! TEXT CHANNEL CRITICAL
    guild = client.guilds->get(data.guild_id);
    author = client.users->get(data.author.id);
    member = guild.members->get(author.id);
    content = data.content;
    timestamp = data.timestamp;
    edited_timestamp = data.edited_timestamp;
    tts = data.tts;
    mention_everyone = data.mention_everyone;

    mentions = Gallon(([]));
    attachments = Gallon(([]));
    embeds = Gallon(([]));
    reactions = Gallon(([]));
    nonce = data.nonce;
    pinned = data.pinned;
    webhook_id = data.webhook_id; // TODO: convert to Webhook
    type = data.type;
  }
}
