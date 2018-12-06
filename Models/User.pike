/**
* @param {string} id - The ID of the user
* @param {string} username - The username of the user
* @param {string} discriminator - The user's tag
* @param {string|Val.Null} avatar - The user's avatar hash
* @param {bool} bot - Whether the user is a bot or not
* @param {bool} mfa_enabled - Whether the user has two factor Auth enabled
* @param {string} locale - The user's chosen language
* @param {bool} verified - Whether the email on the account has been verified
* @param {string} email - The user's email
* @param {integer} flags - The badges on the user's account
* @param {integer} premium_type - tHe type of Nitro the user has
*/
class User {
  string id;
  string username;
  string discriminator;
  string|Val.Null avatar;

  bool bot;
  bool mfa_enabled;

  string locale;

  bool verified;

  string email;

  int flags;
  int premium_type;

  void create(mapping data) {
    id = data.id;
    username = data.username;
    discriminator = data.discriminator;
    avatar = data.avatar;
    bot = data.bot;
    mfa_enabled = data.enabled;
    locale = data.locale;
    verified = data.verified;
    email = data.email;
    flags = data.flags;
    premium_type = data.premium_type;
  }
}
