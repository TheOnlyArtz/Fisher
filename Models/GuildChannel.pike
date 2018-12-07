/**
* @param {string} name - The channel's name
* @param {array} permission_overwrites - The channels permission overwrites
* @param {string|Val.Null} parent_id - The parent channel string ID
* @param {int} position - The position of the channel (up to down)
* @param {Guild} channel - The guild the channel is at
* @param {int} type - The channel's type
* @param {string} id - The channels id
*/
class GuildChannel {
  string name;
  array permission_overwrites;
  string|Val.Null parent_id;
  int position;
  Guild guild;
  int type;
  string id;

  protected Client client;

  void create(Client c, mapping data) {
    name = data.name;
    permission_overwrites = data.permission_overwrites;
    parent_id = data.parent_id;
    position = data.position;

    client = c;
  }
}
