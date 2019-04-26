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
    parentId = data.parent_id || data.parentId;
    guild_id = g ? g.id : data.guild_id;
    guild = g || RestUtils()->fetchCacheGuild(guild_id, client);

    permissionOverwrites = Gallon(([]));
    foreach(data.permission_overwrites, mapping data) {
      permissionOverwrites->assign(data.id, Permission(client, data, guild||UNDEFINED));
    }
  }
}
