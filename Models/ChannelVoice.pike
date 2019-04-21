class ChannelVoice {
  inherit GuildChannel;

  bool nsfw;
  int userLimit;
  int bitrate;

  void create(Client c, mapping data, void|Guild g) {
    client = c;

    name = data.name;
    type = data.type;
    id = data.id;
    parentId = data.parent_id || data.parentId;
    position = data.position;
    guild = g;
    nsfw = data.nsfw;
    userLimit = data.user_limit || data.userLimit;
    bitrate = data.bitrate;

    permissionOverwrites = Gallon(([]));
    foreach(data.permission_overwrites, mapping data) {
      permissionOverwrites->assign(data.id, Permission(client, data, guild||UNDEFINED));
    }
  }
}
