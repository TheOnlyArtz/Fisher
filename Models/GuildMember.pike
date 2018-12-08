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

  protected Client client;

  /**
  * The constructor
  * @param {Client} c - The client
  * @param {mapping} data - The data
  */
  void create(Client c, mapping data) {
    user = data.user;
    nickname = data.nick;
    roles = data.roles;
    joined_at = data.joined_at;
    deafend = data.deaf;
    muted = data.mute;

    client = c;
  }
}
