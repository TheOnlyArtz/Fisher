class GuildTextChannel {
  inherit GuildChannel;

  string topic;
  string lastMessageId;
  Gallon messages;

  protected Client client;
  protected Guild guild;
  void create(Client c, Guild g, mapping data) {
    client = c;
    guild = g;

    name = data.name;
    permissionOverwrites = data.permission_overwrites || data.permissionOverwrites;
    parentId = data.parent_id || data.parentId;
    position = data.position;
    guild = client.guilds->get(data.guild_id);
    type = data.type;
    id = data.id;

    topic = data.topic;
    lastMessageId = data.last_message_id;

    messages = Gallon(([]));
  }
}
