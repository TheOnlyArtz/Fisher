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
  array roles;
  string joined_at;
  bool deafend;
  bool muted;

  void create(data) {
    user = User(data.user);
    nick = data.nick;
    roles = data.roles;
    joined_at = data.joined_at;
    deafend = data.deaf;
    muted = data.mute
  }
}
