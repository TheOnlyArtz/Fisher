class GuildTextChannel {
  inherit GuildChannel;

  string topic;
  string lastMessageId;

  protected Client client;

  void create(Client c, mapping data) {
    client = c;

    name = data.name;
    permissionOverwrites = data.permission_overwrites || data.permissionOverwrites;
    parentId = data.parent_id || data.parentId;
    position = data.position;
    guild = client.guilds->get(data.guild_id);
    type = data.type;
    id = data.id;

    topic = data.topic;
    lastMessageId = data.last_message_id;
  }
}
