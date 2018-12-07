#include "GuildChannel.pike"
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
  inhriet GuildChannel;

  void create(Client c, mapping data) {
    client = c;

    id = data.id;
    type = data.type;
    name = data.name;
    permission_overwrites = data.permission;
    parent_id = data.parent_id;
    guild = client.guilds[data.guild_id];
  }
}
