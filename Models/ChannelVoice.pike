class ChannelVoice {
  inherit GuildChannel;

  bool nsfw;
  int userLimit;
  int bitrate;

  void create(Client c, mapping data, void|Guild g) {

    name = data.name;
    type = data.type;
    id = data.id;
    parentId = data.parent_id || data.parentId;
    position = data.position;
    guild_id = g ? g.id : data.guild_id;
    guild = g || RestUtils()->fetchCacheGuild(guild_id, c);
    nsfw = data.nsfw;
    userLimit = data.user_limit || data.userLimit;
    bitrate = data.bitrate;

    permissionOverwrites = Gallon(([]));
    foreach(data.permission_overwrites, mapping data) {
      permissionOverwrites->assign(data.id, Permission(c, data, guild||UNDEFINED));
    }
  }
}
