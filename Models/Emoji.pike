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

  bool requireColons;
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
    requireColons = data.require_colons || data.requireColons;
    managed = data.managed;
    animated = data.animated;

    foreach (data.roles, string id) {
      roles->assign(id, guild.roles->get(id));
    }
  }
}
