#include "../GuildMember.pike"
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

  // mapping 
}
