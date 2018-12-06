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
  mapping cacheMembers(Guild guild, array data) {
    foreach(data, mixed member) {
      member.user = User(member.user);

      member = GuildMember(member);
      guild.members[member.user.id] = member;
    }
  }
}
