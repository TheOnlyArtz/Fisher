class Message {
  string id;
  GuildTextChannel channel;// TO DO TEXTCHANNEL
  Guild guild;
  User author;
  GuildMember member;
  string content;
  string timestamp;
  string|Val.Null editedTimestamp;
  bool tts;
  bool mentionEveryone;

  Gallon mentions; // EVERYONE, USERS, ROLES
  Gallon attachments;
  Gallon embeds;
  Gallon reactions;

  string|Val.Null nonce;
  bool pinned;
  string webhookId;
  int type;
  // TODO message activity and message application

  /**
  * TODO:
  * Look at: message.activity and message.application
  * See: https://discordapp.com/developers/docs/resources/channel#message-object
  **/

  void create(Client client, mapping data) {
    id = data.id;
    channel = GuildTextChannel(client, data);
    guild = client.guilds->get(data.guild_id);
    author = client.users->get(data.author.id);
    member = guild.members->get(author.id);
    content = data.content;
    timestamp = data.timestamp;
    editedTimestamp = data.edited_timestamp || data.editedTimestamp;
    tts = data.tts;
    mentionEveryone = data.mention_everyone || data.mentionEveryone;

    mentions = Gallon(([]));
    attachments = Gallon(([]));
    embeds = Gallon(([]));
    reactions = Gallon(([]));
    nonce = data.nonce;
    pinned = data.pinned;
    webhookId = data.webhook_id || data.webhookId; // TODO: convert to Webhook
    type = data.type;
  }
}
