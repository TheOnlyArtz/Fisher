class ChannelVoice {
  inherit GuildChannel;

  bool nsfw;
  int userLimit;
  int bitrate;

  void create(Client c, mapping data) {
    client = c;

    name = data.name;
    type = data.type;
    id = data.id;
    permissionOverwrites = data.permission_overwrites || data.permissionOverwrites;
    parentId = data.parent_id || data.parentId;
    position = data.position;
    guild = client.guilds->get(data.guild_id);
    nsfw = data.nsfw;
    userLimit = data.user_limit || data.userLimit;
    bitrate = data.bitrate;
  }
}
