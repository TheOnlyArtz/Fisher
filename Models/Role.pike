/**
* @param {string} id - The role's ID
* @param {string} name - The role's name
* @param {int} color - The integer representation of the hex color code
* @param {bool} hoist - Whether the role is pinned to the user listing
* @param {int} position - the Position of the role
* @param {int} permissions - The permissions bit set
* @param {bool} managed - Whether this role is managed by an integration
* @param {bool} mentionable - Whether this role is mentionable
*/
class Role {
  string id;
  string name;

  bool hoist;
  bool managed;
  bool mentionable;

  int color;
  int position;
  int permissions;

  protected Client client;
  protected Guild guild;
  /**
  * The constructor
  * @param {Client} c - The client
  * @param {mapping} data
  */
  void create(Client c, Guild g, mapping data) {
    client = c;
    guild = g;
    id = data.id;
    name = data.name;
    color = data.color;
    hoist = data.hoist;
    permissions = data.permissions;
    managed = data.managed;
    mentionable = data.mentionable;
  }

  /**
  * A function to indicate if the Role has a specific permission
  * @param {string|int} perm - The permission which can be either a name or a bitfield
  * @example
  * bool own = guild.roles->get("ID")->ownPermission("SEND_MESSAGES");
  * if (!own) return;
  */
  bool ownPermission(string|int perm) {
    return PermissionUtils()->own(permissions, perm);
  }
}
