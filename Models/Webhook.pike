class Webhook {
  string id;
  Guild|Val.Null guild;
  mixed channel;
  User|Val.Null user;
  string|Val.Null name;
  string|Val.Null avatar;
  string token;

  void create(Client client, mapping data) {
    id = data.id || Val.null;
    guild = RestUtils()->fetchCacheGuild(data.guild_id, client);
    channel = RestUtils()->fetchCacheChannel(data.channel_id, client);
    name = data.name || Val.null;
    user = RestUtils()->fetchCacheUser(data.user.id, client);
    avatar = data.avatar || Val.null;
    token = data.token || Val.null;
  }
}
