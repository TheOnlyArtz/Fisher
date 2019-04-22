/**
 * The event handlers callbacks go in here
 * @property {function} ready - The READY event handler
 * @property {function} guild_create - The GUILD_CREATE event handler
 */
class EventHandlers {
  array ready;

  array channelCreate;
  array channelUpdate;
  array channelDelete;
  array channelPinsUpdate;

  array guildCreate;

  array guildUpdate;
  array guildDelete;
  array guildBanAdd;
  array guildBanRemove;
  array guildEmojiUpdate;
  array guildEmojiRemove;
  array guildEmojiAdd;
  array guildIntegrationUpdate;
  array guildMemberAdd;
  array guildMemberRemove;
  array guildMembersChunk;
  array guildMemberUpdate;
  array guildRoleCreate;
  array guildRoleDelete;
  array guildRoleUpdate;

  array messageCreate;
  array messageUpdate;
  array messageDelete;
  array messageDeleteBulk;
  array messageReactionAdd;
  array messageReactionRemove;
  array messageReactionRemoveAll;

  array presenceUpdate;
  array typingStart;
  array userUpdate;

  array voiceStateUpdate;
  array voiceServerUpdate;
  array webhooksUpdate;

  void create() {
    ready = ({}); // ✅
    guildCreate = ({}); // ✅

    channelCreate = ({}); // ✅
    channelUpdate = ({}); // ✅
    channelDelete = ({}); // ✅
    channelPinsUpdate = ({}); // ✅
    guildUpdate = ({}); // ✅
    guildDelete = ({}); // ✅
    guildBanAdd = ({}); // ✅
    guildBanRemove = ({}); // ✅
    guildEmojiUpdate = ({}); // ✅
    guildEmojiRemove = ({}); // ✅
    guildEmojiAdd = ({}); // ✅
    guildIntegrationUpdate = ({}); // ✅
    guildMemberAdd = ({}); // ✅
    guildMemberRemove = ({}); // ✅
    guildMemberUpdate = ({}); // ✅
    guildMembersChunk = ({}); // HOLD
    guildRoleCreate = ({}); // ✅
    guildRoleUpdate = ({});// ✅
    guildRoleDelete = ({});// ✅
    messageCreate = ({});// ✅
    messageUpdate = ({});// ✅
    messageDelete = ({});// ✅
    messageDeleteBulk = ({});
    messageReactionAdd = ({});// ✅
    messageReactionRemove = ({});// ✅
    messageReactionRemoveAll = ({});// ✅
    presenceUpdate = ({});// ✅
    typingStart = ({});// ✅
    userUpdate = ({});// ✅
    voiceStateUpdate = ({}); // ON HOLD
    voiceServerUpdate = ({}); // ON HOLD
    webhooksUpdate = ({}); // ON HOLD
  }
}
