/**
 * Here all the events with OP code 0 will be handled!
 * @property {WSHandler} wsHandler - The websocket handler
 * @param {Client} client - The client.
 */
class EventDispatcher {
  WSHandler wsHandler;
  Client client;

  protected GuildCacher guildCacher;
  /**
  * The constructor
  */
  void create(WSHandler w) {
    wsHandler = w;
    client = w.client;
    guildCacher = GuildCacher(client);
  }

  /**
   * handles the READY event
   * @param {mapping} data
   */
  void ready(mapping data) {
    client.user = ClientUser(client, data.user);

    wsHandler.wsManager.wsSessionID = data.session_id;

    foreach(data.guilds, mapping g) client.guilds->assign(g.id, ([]));
    // Emit the event
    client->emit("ready", client);

    // Start heartbeating
    wsHandler.wsManager->heartbeat(wsHandler.wsManager.heartbeat_interval/1000);
  }

  /**
   * handles the GUILD_CREATE event
   * @param {mapping} data
   */
  void guildCreate(mapping data) {
    Guild guild = Guild(client, data);
    bool alreadyInside = client.guilds->get(data.id);

    guildCacher->cacheRoles(guild, data.roles);
    guildCacher->cacheMembers(guild, data.members);
    guildCacher->cacheChannels(guild, data.channels);
    guildCacher->cacheEmojis(guild, data.emojis);
    client.cacher->cacheGuild(guild);

    if (!alreadyInside)
      client->emit("guildCreate", guild, client);
  }

  void guildUpdate(mapping data) {
    Guild oldGuild = client.guilds->get(data.id);
    Guild newGuild = Guild(client, data);

    guildCacher->cacheRoles(newGuild, data.roles);
    guildCacher->cacheEmojis(newGuild, data.emojis);
    client.cacher->cacheGuild(newGuild);

    array diffs = MiscUtils()->mappingDiff(oldGuild, newGuild);

    client.emit("guildUpdate", newGuild, oldGuild, diffs, client);

  }

  void guildDelete(mapping data) {
    // TODO:
  }

  void guildBanAdd(mapping data) {
    Guild guild = client.guilds->get(data.guild_id);
    User user = client.users->get(data.user.id) ? client.users->get(data.user.id) : User(client, data.user);

    if (client.users->get(data.user.id))
      client.users->delete(data.user.id);

    if (guild.members->get(data.user.id))
      guild.members->delete(data.user.id);

    if (guild)
      client->emit("guildBanAdd", guild, user, client);
  }

  void guildBanRemove(mapping data) {
    Guild guild = client.guilds->get(data.guild_id);
    User user = User(client, data.user);

    if (guild)
      client->emit("guildBanRemove", client, guild, user);
  }

  /**
  * Emoji's event handlers
  * - START -
  */
  void guildEmojisUpdate(mapping data) {
    Guild guild = client.guilds->get(data.guild_id);
    if (!guild || !guild.emojis) return;

    Gallon deletedEmojis = Gallon(copy_value(guild.emojis.iterable));
    array diffs;
    Emoji cached;
    Emoji newEmoji;

    foreach(data.emojis, mapping emoji) {
      cached = guild.emojis->get(emoji.id);
      newEmoji = Emoji(client, guild, emoji);

      if (cached) {
        diffs =  MiscUtils()->mappingDiff(cached, newEmoji);
        deletedEmojis->delete(emoji.id);
        if (sizeof(diffs) > 1) {
          // Emit guildEmojisUpdate
          emojiUpdate(newEmoji, cached, diffs, client);
        }
      } else {
        // Emoji is added
        emojiAdd(guild, newEmoji);
      }
    }

    foreach(deletedEmojis->arrayOfValues(), Emoji emoji) {
      emojiRemove(emoji);
    }
  }

  void emojiUpdate(Emoji newEmoji, Emoji cached, array diffs, Client client) {
    client.emojis->assign(newEmoji.id, newEmoji);
    cached.guild.emojis->assign(newEmoji.id, newEmoji);
    client->emit("guildEmojiUpdate", newEmoji, cached, diffs, client);
  }

  void emojiAdd(Guild guild, Emoji newEmoji) {
    client.emojis->assign(newEmoji.id, newEmoji);
    guild.emojis->assign(newEmoji.id, newEmoji);
    client->emit("guildEmojiAdd", newEmoji, client);
  }

  void emojiRemove(Emoji emoji) {
    emoji.guild.emojis->delete(emoji.id);
    client.emojis->delete(emoji.id);

    client->emit("guildEmojiRemove", emoji);
  }

  /**
  * Emoji's event handlers
  * - END -
  */

  // TODO: Guild integrations update
  void guildMemberAdd(mapping data) {
    Guild guild = client.guilds->get(data.guild_id);
    if (!guild) return;

    GuildMember member = GuildMember(client, guild, data);

    // Caching
    guild.members->assign(member.id, member);
    client.users->assign(member.id, member.user);

    client->emit("guildMemberAdd", member);
  }

  void guildMemberRemove(mapping data) {
    Guild guild = client.guilds->get(data.guild_id);
    if (!guild) return;

    User user = client.user->get(data.user.id);
    if (!user) user = User(client, data);

    // Remove from caching
    guild.members->delete(user.id);
    client.users->delete(user.id);

    client->emit("guildMemberRemove", guild, user);
  }

  void guildMemberUpdate(mapping data) {
    Guild guild = client.guilds->get(data.guild_id);
    if (!guild) return;

    GuildMember cached = guild.members->get(data.user.id);
    if (!cached) return;

    GuildMember newMember = MiscUtils()->cloneObject(GuildMember, data, client, guild);
    guild.members->assign(data.user.id, newMember);

    array diffs = MiscUtils()->mappingDiff(cached, newMember);

    client->emit("guildMemberUpdate", guild, newMember, cached, diffs, client);
  }

  // TODO:
  void guildMemberChunk(mapping data) {

  }

  void guildRoleCreate(mapping data) {
    Guild guild = client.guilds->get(data.guild_id);
    if (!guild) return;

    guild.roles->assign(data.role.id, Role(client, guild, data.role));
    Role role = guild.roles->get(data.role.id);

    client->emit("guildRoleCreate", guild, role, client);
  }

  void guildRoleUpdate(mapping data) {

    Guild guild = client.guilds->get(data.guild_id);
    if (!guild) return;

    Role cached = guild.roles->get(data.role.id);
    if (!cached) return;

    Role newRole = MiscUtils()->cloneObject(Role, data.role, client, guild);
    guild.roles->assign(data.role.id, newRole);

    array diffs = MiscUtils()->mappingDiff(cached, newRole);

    if (sizeof(diffs) != 0)
      client->emit("guildRoleUpdate", guild, newRole, cached, diffs, client);
  }

  void guildRoleDelete(mapping data) {
    Guild guild = client.guilds->get(data.guild_id);
    if (!guild) return;

    Role deletedRole = guild.roles->get(data.role_id);
    if (!deletedRole) return;
    guild.roles->delete(data.role_id);
    client->emit("guildRoleDelete", guild, deletedRole, client);
  }

  void messageCreate(mapping data) {
    Message theMessage = Message(client, data);

    // TODO: Have max_messages cache to every channel
    if (!theMessage.channel) return;
    theMessage.channel.messages->assign(theMessage.id, theMessage);
    theMessage.channel.lastMessageId = theMessage.id;

    client->emit("messageCreate", theMessage, client);
  }

  void messageUpdate(mapping data) {

  }
}
