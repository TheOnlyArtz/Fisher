/**
 * The event handlers callbacks go in here
 * @property {function} ready - The READY event handler
 * @property {function} guild_create - The GUILD_CREATE event handler
 */
class EventHandlers {
  function ready;
  function guildCreate;

  function channelCreate;
  function channelUpdate;
  function channelDelete;
  function channelPinsUpdate;
  function guildUpdate;
  function guildDelete;
  function guildBanAdd;
  function guildBanRemove;
  function guildEmojisUpdate;
  function guildIntegrationUpdate;
  function guildMemberAdd;
  function guildMemberRemove;
  function guildMembersChunk;
  function guildMemberUpdate;
  function guildRoleCreate;
  function guildRoleDelete;
  function guildRoleUpdate;
  function messageCreate;
  function messageUpdate;
  function messageDelete;
  function messageDeleteBulk;
  function messageReactionAdd;
  function messageReactionDelete;
  function messageReactionRemoveAll;
  function presenceUpdate;
  function typingStart;
  function userUpdate;
  function voiceStateUpdate;
  function voiceServerUpdate;
  function webhooksUpdate;

  void create() {
    ready = lambda() {};
    guildCreate = lambda() {};

    channelCreate = lambda() {};
    channelUpdate = lambda() {};
    channelDelete = lambda() {};
    channelPinsUpdate = lambda() {};
    guildUpdate = lambda() {};
    guildDelete = lambda() {};
    guildBanAdd = lambda() {};
    guildBanRemove = lambda() {};
    guildEmojisUpdate = lambda() {};
    guildIntegrationUpdate = lambda() {};
    guildMemberAdd = lambda() {};
    guildMemberRemove = lambda() {};
    guildMemberUpdate = lambda() {};
    guildMembersChunk = lambda() {};
    guildRoleCreate = lambda() {};
    guildRoleUpdate = lambda() {};
    guildRoleDelete = lambda() {};
    messageCreate = lambda() {};
    messageUpdate = lambda() {};
    messageDelete = lambda() {};
    messageDeleteBulk = lambda() {};
    messageReactionAdd = lambda() {};
    messageReactionDelete = lambda() {};
    messageReactionRemoveAll = lambda() {};
    presenceUpdate = lambda() {};
    typingStart = lambda() {};
    userUpdate = lambda() {};
    voiceStateUpdate = lambda() {};
    voiceServerUpdate = lambda() {};
    webhooksUpdate = lambda() {};
  }
}
