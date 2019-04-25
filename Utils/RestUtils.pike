class RestUtils {
  mixed getChannelAccordingToType(int type, mapping data, Client client, void|Guild g) {
    switch (type) {
      case 0:
        return GuildTextChannel(client, data, g);
        break;
      case 1:
        return ChannelDM(client, data);
        break;
      case 2:
        return ChannelVoice(client, data, g);
        break;
      case 4:
        return ChannelCategory(client, data, g);
        break;
    }
  }

  string constructAttachmentUpload(string file, string name, bool content, string contentStr) {
    string CONTENT_TYPE = "Content-Type: application/octet-stream;";
    string CONTENT_DISPOS_ATTACH = sprintf("Content-Disposition: form-data; name=\"file\"; filename=\"%s\";", name);
    string CONTENT_DISPOS_CONTENT = sprintf("Content-Disposition: form-data; name=\"content\";");

    string start = sprintf("\r\n--main\r\n%s\r\n%s\r\n\r\n%s\r\n", CONTENT_TYPE,CONTENT_DISPOS_ATTACH,file);

    if (content) {
      string mid = sprintf("--main\r\n%s\r\n\r\n%s\r\n", CONTENT_DISPOS_CONTENT, contentStr);
      return start + mid + "--main--";
    }

    return start + "--main--";
  }

  /* Auto fetch section */
  Guild fetchCacheGuild(string guildId, Client client) {
    if (client.guilds->get(guildId)) return client.guilds->get(guildId);
    Guild g = client.api->getGuild(guildId);

    client.guilds->assign(guildId, g);
    return g;
  }

  mixed fetchCacheChannel(string channelId, Client client) {
    if (client.channels->get(channelId)) return client.channels->get(channelId);

    mixed c = client.api->getChannel(channelId);
    client.channels->assign(channelId, c);

    return c;
  }

  User fetchCacheUser(string userId, Client client) {
    if (client.users->get(userId)) return client.users->get(userId);

    User u = client.api->getUser(userId);
    client.users->assign(userId, u);

    return u;
  }

  Emoji fetchCacheEmoji(string emojiId, Client client, Guild|void guild) {
    if (client.emojis->get(emojiId)) return client.emojis->get(emojiId);

    Emoji e = client.api->getEmoji(emojiId);
    client.emojis->assign(emojiId, e);
    if (guild) guild.emojis->assign(emojiId, e);

    return e;
  }

  Role fetchCacheRole(string roleId, Client client, Guild|void guild) {
    if (guild.roles->get(roleId)) return guild.roles->get(roleId);

    Role r = client.api->getRole(roleId);
    if (guild) guild.roles->assign(roleId, r);

    return r;
  }

  GuildMember fetchCacheGuildMember(string memberId, Client client, Guild|void guild) {
    if (guild.members->get(memberId)) return guild.members->get(memberId);

    GuildMember g = client.api->getGuildMember(guild.id, memberId);
    guild.members->assign(memberId, g);

    return g;
  }
}
