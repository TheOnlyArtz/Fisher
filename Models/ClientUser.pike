/*
* The ClientUser is a User with more features
* @property {string} avatar - The avatar hash
* @property {string} descriminator - The descriminator
* @property {string} id - The ID
* @property {string} username - The username
* @property {Val.Boolean} verified - If the user is verified or not
* @property {string|Val.Null} email - The user's email
* @property {Val.Boolean} mfa_enabled - If mfa enabled or not
* @property {Val.Boolean} bot - If the client is a bot or not
*/
class ClientUser {
  string avatar;
  string descriminator;
  string id;
  string username;
  Val.Boolean verified;
  string|Val.Null email;
  Val.Boolean mfa_enabled;
  Val.Boolean bot;

  /*
  * The constructor
  * @param {mapping} data - The user data
  */
  void create(mapping data) {
    avatar = data.avatar;
    descriminator = data.discriminator;
    id = data.id;
    username = data.username;
    email = data.email;
    mfa_enabled = data.mfa_enabled;
    bot = data.bot;
  }
}
