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
      guild.members[member.user.id] = member;
    }
  }

  void cacheChannels(Client client, Guild guild, array data) {
    foreach(data, mixed channel) {
      switch(channel.type) {
        case 2:
          guild.channels[channel.id] = ChannelVoice(client, channel);
          break;
        case 4:
          guild.channels[channel.id] = ChannelCategory(client, channel);
          break;
      }
    }
  }

  void cacheRoles(Client client, Guild guild, array data) {
    foreach(data, mixed role) {
      guild.roles[role.id] = Role(client, role);
    }
  }
}
