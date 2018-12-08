class ChannelVoice {
  inherit GuildChannel;

  bool nsfw;
  int user_limit;
  int bitrate;

  void create(Client c, mapping data) {
    client = c;

    name = data.name;
    type = data.type;
    id = data.id;
    permission_overwrites = data.permission_overwrites;
    parent_id = data.parent_id;
    position = data.position;
    guild = client.guilds->get(data.guild_id);
    nsfw = data.nsfw;
    user_limit = data.user_limit;
    bitrate = data.bitrate;
  }
}
