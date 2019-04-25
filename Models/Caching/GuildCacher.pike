/**
* Used to help with guild caching related traffic
* - Members
* - Channels
* - Presences
* - Emojis
* - Roles
*/
class GuildCacher {
  Client client;

  void create(Client c) {
    client = c;
  }

  void cacheMembers(Guild guild, array data) {
    foreach(data, mixed member) {
      array roles = member.roles;

      client.cacher->cacheUser(member.user);
      member = GuildMember(client, guild, member);
      guild.members->assign(member.user.id, member);
    }
  }

  void cacheChannels(Guild guild, array data) {
    foreach(data, mixed channel) {
      mixed channelO = RestUtils()->getChannelAccordingToType(channel.type, channel, client, guild);
      guild.channels->assign(channel.id, channelO);
      client.channels->assign(channel.id, channelO);
    }
  }

  void cacheRoles(Guild guild, array data) {
    foreach(data, mixed role) {
      guild.roles->assign(role.id, Role(client, guild, role));
    }
  }

  void cacheEmojis(Guild guild, array data) {
    foreach(data, mixed emoji) {
      guild.emojis->assign(emoji.id, Emoji(client, guild, emoji));
      client.cacher->cacheEmoji(guild, emoji);
    }
  }

  void cachePresences(Guild guild, array data) {
    GuildMember member;
    Presence toAssign;
    foreach(data, mixed presence) {
      member = guild.members->get(presence.user.id);
      toAssign = Presence(presence);
      guild.presences->assign(presence.user.id, toAssign);
      member.presence = toAssign;
    }
  }
}
