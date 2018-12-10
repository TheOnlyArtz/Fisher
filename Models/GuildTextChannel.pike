class GuildTextChannel {
  inherit GuildChannel;

  string topic;
  string last_message_id;

  protected Client client;

  void create(Client c, mapping data) {
    client = c;

    name = data.name;
    permission_overwrites = data.permission_overwrites;
    parent_id = data.parent_id;
    position = data.position;
    guild = client.guilds->get(data.guild_id);
    type = data.type;
    id = data.id;

    topic = data.topic;
    last_message_id = data.last_message_id;
  }
}
