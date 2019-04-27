/**
*
*
* TODO DOCUMENTATION
*
*
*/
class Emoji {
  string name;

  Gallon roles;
  Guild guild;

  bool|Val.Null requireColons;
  string|Val.Null id;
  User|Val.Null user;
  bool|Val.Null managed;
  bool|Val.Null animated;

  void create(Client c, Guild g, mapping data) {
    guild = g;

    id = data.id;
    name = data.name;
    roles = Gallon(([]));
    user = user ? User(c, data) : Val.null;
    requireColons = data.require_colons || data.requireColons;
    managed = data.managed;
    animated = data.animated;

    foreach (data.roles, string id) {
      roles->assign(id, guild.roles->get(id));
    }
  }
}
