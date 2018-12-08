/**
*
*
* TODO DOCUMENTATION
*
*
*/
class Emoji {
  string|Val.Null id;
  string name;

  Gallon roles;
  Guild guild;
  User|Val.Null user;

  bool require_colons;
  bool managed;
  bool animated;

  protected Client client;

  void create(Client c, Guild g, mapping data) {
    client = c;
    guild = g;

    id = data.id;
    name = data.name;
    roles = Gallon(([]));
    user = user ? User(client, data) : Val.null;
    require_colons = data.require_colons;
    managed = data.managed;
    animated = data.animated;

    foreach (data.roles, string id) {
      roles->assign(id, guild.roles->get(id));
    }
  }
}
