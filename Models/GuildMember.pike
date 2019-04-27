/**
*
* @param {User} user - The user object
* @param {string|Val.Null} nickname - The nickname of the member (if there's one)
* @param {mapping} roles - The roles which the member has
* @param {string} joined_at - Then the member join the guild
* @param {bool} deafend - Whether the user is deafend
* @param {bool} muted - Whether the user is deafend
*/
class GuildMember {
  User user;
  string|Val.Null nickname;
  Gallon roles;
  string joinedAt;
  bool deafend;
  bool muted;
  Presence presence;
  Guild guild;

  /**
  * The constructor
  * @param {Client} c - The client
  * @param {mapping} data - The data
  */
  void create(Client c, Guild g, mapping data) {
    user = c.users->get(data.user.id) || User(c, data.user);
    nickname = data.nick;
    roles = Gallon(([]));
    joinedAt = data.joined_at || data.joinedAt;
    deafend = data.deaf;
    muted = data.mute;

    guild = g;

    foreach(data.roles, string key) {
      roles->assign(key, guild.roles->get(key));
    }
  }
}
