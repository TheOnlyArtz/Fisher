/**
* @param {string} name - The channel's name
* @param {array} permission_overwrites - The channels permission overwrites
* @param {string|Val.Null} parent_id - The parent channel string ID
* @param {int} position - The position of the channel (up to down)
* @param {Guild} channel - The guild the channel is at
* @param {int} type - The channel's type
* @param {string} id - The channels id
*/
class ChannelCategory {
  inherit GuildChannel;

  void create(Client c, mapping data, void|Guild g) {
    client = c;

    id = data.id;
    type = data.type;
    name = data.name;
    permissionOverwrites = data.permission_overwrites || data.permissionOverwrites;
    parentId = data.parent_id || data.parentId;
    guild = g;
  }
}
