/**
* Used to help with guild caching related traffic
* - Members
* - Channels
* - Presences
* - Emojis
* - Roles
*/
class GuildCacher {
  void cacheMembers(Client client, Guild guild, array data) {
    foreach(data, mixed member) {
      member.user = User(client, member.user);

      member = GuildMember(client, member);
      guild.members->assign(member.user.id, member);
      client.users->assign(member.user.id, member.user);
    }
  }

  void cacheChannels(Client client, Guild guild, array data) {
    foreach(data, mixed channel) {
      switch(channel.type) {
        case 2:
          guild.channels->assign(channel.id, ChannelVoice(client, channel));
          break;
        case 4:
          guild.channels->assign(channel.id, ChannelCategory(client, channel));
          break;
      }
      client.channels->assign(channel.id, guild.channels[channel.id]);
    }
  }

  void cacheRoles(Client client, Guild guild, array data) {
    foreach(data, mixed role) {
      guild.roles->assign(role.id, Role(client, role));
    }
  }
}
