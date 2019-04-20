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
  array permissionOverwrites;
  string|Val.Null parentId;
  int position;
  Guild guild;
  int type;
  string id;

  protected Client client;
}
