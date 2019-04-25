class GuildTextChannel {
  inherit GuildChannel;

  string topic;
  string lastMessageId;
  Gallon messages;

  protected Client client;
  void create(Client c, mapping data, void|Guild g) {
    client = c;
    guild_id = g ? g.id : data.guild_id;
    guild = g || RestUtils()->fetchCacheGuild(guild_id, client);
    name = data.name;
    parentId = data.parent_id || data.parentId;
    position = data.position;
    type = data.type;
    id = data.id;

    topic = data.topic;
    lastMessageId = data.last_message_id;

    messages = Gallon(([]));

    permissionOverwrites = Gallon(([]));
    foreach(data.permission_overwrites, mapping data) {
      permissionOverwrites->assign(data.id, Permission(client, data, guild||UNDEFINED));
    }

  }
}
