class Message {
  string|Val.Null id;
  GuildTextChannel channel;// TO DO TEXTCHANNEL
  User|Val.Null author;
  string|Val.Null content;
  string|Val.Null timestamp;
  bool|Val.Null tts;
  bool|Val.Null mentionEveryone;

  Gallon|Val.Null mentions; // EVERYONE, USERS, ROLES
  Gallon|Val.Null attachments;
  array embeds;

  Gallon|Val.Null reactions;
  GuildMember|Val.Null member;
  Guild|Val.Null guild;
  string|Val.Null editedTimestamp;
  string|Val.Null nonce;
  string|Val.Null webhookId;

  bool|Val.Null pinned;
  int|Val.Null type;
  // TODO message activity and message application

  /**
  * TODO:
  * Look at: message.activity and message.application
  * See: https://discordapp.com/developers/docs/resources/channel#message-object
  **/

  void create(Client client, mapping data) {
    id = data.id;
    channel = RestUtils()->fetchCacheChannel(data.channel_id, client);
    if (channel.guild_id)
      guild = RestUtils()->fetchCacheGuild(channel.guild_id, client);
    if (data.author && data.author.discriminator != "0000") {
      author = RestUtils()->fetchCacheUser(data.author.id,client);
      member = guild ? RestUtils()->fetchCacheGuildMember(author.id, client, guild) : Val.Null; // TODO: auto fetch
    } else author = data.author;
    content = data.content;
    timestamp = data.timestamp;
    editedTimestamp = data.edited_timestamp || data.editedTimestamp;
    tts = data.tts;
    mentionEveryone = data.mention_everyone || data.mentionEveryone;

    mentions = Gallon(([]));
    attachments = Gallon(([]));
    embeds = data.embeds;
    reactions = Gallon(([]));
    nonce = data.nonce;
    pinned = data.pinned;
    webhookId = data.webhook_id || data.webhookId || Val.Null; // TODO: convert to Webhook
    type = data.type;

    if (data.reactions)
      MessageCacher()->cacheReactions(client, this, data.reactions);
    MessageCacher()->cacheMentions(client, this, data.mentions);
    MessageCacher()->cacheAttachments(client, this, data.attachments);
  }
}
