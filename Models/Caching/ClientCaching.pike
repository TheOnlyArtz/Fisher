class ClientCaching() {
  protected Client client;

  void create(Client c) {
    client = c;
  }

  void cacheEmoji(Guild guild, mapping emoji) {
    client.emojis->assign(emoji["id"], Emoji(client, guild, emoji));
  }

  void cachePresences(array data) {
    foreach(data, mapping presence) {
      // client.presences->assign(emoji["id"], Emoji(client, guild, emoji));
    }
  }

  void cacheUser(mapping user) {
    client.users->assign(user["id"], User(client, user));
  }

  void cacheChannel(mapping channel, object ChannelType) {
      Guild g = client.guilds->get(channel["guild_id"]);
      client.channels->assign(channel["id"], ChannelType(client, g ? g : ([]), channel));
  }

  void cacheGuild(Guild guild) {
      client.guilds->assign(guild["id"], guild);
  }
}
