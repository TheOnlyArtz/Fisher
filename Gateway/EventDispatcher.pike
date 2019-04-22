/**
 * Here all the events with OP code 0 will be handled!
 * @property {WSHandler} wsHandler - The websocket handler
 * @param {Client} client - The client.
 */
class EventDispatcher {
  WSHandler wsHandler;
  Client client;

  protected GuildCacher guildCacher;
  protected RestUtils restUtils;
  /**
  * The constructor
  */
  void create(WSHandler w) {
    wsHandler = w;
    client = w.client;
    guildCacher = GuildCacher(client);
    restUtils = RestUtils();
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

  void channelCreate(mapping data) {
    mixed channelO = restUtils->getChannelAccordingToType(data.type, data, client);
    if (data.type == 0 || data.type == 2 || data.type == 4) {
      Guild guild = restUtils->fetchCacheGuild(data.guild_id, client);
      guild.channels->assign(data.id, channelO);
    }
     client.channels->assign(data.id, channelO);
     client->emit("channelCreate", channelO, client);
  }

  void channelUpdate(mapping data) {
    mixed cached = client.channels->get(data.id);
    if (!cached) return;

    mixed newChannel = restUtils->getChannelAccordingToType(cached.type, data, client);
    MiscUtils()->fixNullables(newChannel, cached);
    client.channels->assign(cached.id, newChannel);
    if (cached.guild) cached.guild.channels->assign(cached.id, newChannel);

    array diffs = MiscUtils()->mappingDiff(cached, newChannel);

    write("%O\n", diffs);
    if (sizeof(diffs) != 0)
      client->emit("channelUpdate", newChannel, cached, diffs, client);
  }

  void channelDelete(mapping data) {
    mixed cached = client.channels->get(data.id);
    if (!cached) return;

    if (cached.guild) cached.guild.channels->delete(data.id);
    client.channels->delete(data.id);

    client->emit("channelDelete", cached, client);
  }

  void channelPinsUpdate(mapping data) {
    mixed channel = restUtils->fetchCacheChannel(data.id, client);
    if (!channel) return;

    client->emit("channelPinsUpdate", channel, client);
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
    Guild oldGuild = restUtils->fetchCacheGuild(data.id, client);
    if (!oldGuild) return;

    Guild newGuild = Guild(client, data);

    guildCacher->cacheRoles(newGuild, data.roles);
    guildCacher->cacheEmojis(newGuild, data.emojis);
    client.cacher->cacheGuild(newGuild);

    array diffs = MiscUtils()->mappingDiff(oldGuild, newGuild);

    client.emit("guildUpdate", newGuild, oldGuild, diffs, client);
  }

  void guildDelete(mapping data) {
    Guild guild = restUtils->fetchCacheGuild(data.guild_id, client);
    if (!guild) return;

    client.guilds->delete(data.guild_id);

    client->emit("guildDelete", guild, client);
    // Delete the guild's users from cache
  }

  void guildBanAdd(mapping data) {
    Guild guild = restUtils->fetchCacheGuild(data.guild_id, client);
    User user = restUtils->fetchCacheUser(data.user.id, client);

    if (client.users->get(data.user.id))
      client.users->delete(data.user.id);

    if (guild.members->get(data.user.id))
      guild.members->delete(data.user.id);

    if (guild)
      client->emit("guildBanAdd", guild, user, client);
  }

  void guildBanRemove(mapping data) {
    Guild guild = restUtils->fetchCacheGuild(data.guild_id, client);
    User user = User(client, data.user);

    if (guild)
      client->emit("guildBanRemove", client, guild, user);
  }

  /**
  * Emoji's event handlers
  * - START -
  */
  void guildEmojisUpdate(mapping data) {
    Guild guild = restUtils->fetchCacheGuild(data.guild_id, client);
    if (!guild || !guild.emojis) return;

    Gallon deletedEmojis = Gallon(copy_value(guild.emojis.iterable));
    array diffs;
    Emoji cached;
    Emoji newEmoji;

    foreach(data.emojis, mapping emoji) {
      cached = restUtils->fetchCacheEmoji(emoji.id, client, guild);
      newEmoji = Emoji(client, guild, emoji);
      if (cached) {
        diffs =  MiscUtils()->mappingDiff(cached, newEmoji);
        deletedEmojis->delete(emoji.id);
        if (sizeof(diffs) != 0) {
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

    client->emit("guildEmojiRemove", emoji, client);
  }

  /**
  * Emoji's event handlers
  * - END -
  */

  // TODO: Guild integrations update
  void guildMemberAdd(mapping data) {
    Guild guild = restUtils->fetchCacheGuild(data.guild_id, client);
    if (!guild) return;

    GuildMember member = GuildMember(client, guild, data);

    // Caching
    guild.members->assign(member.id, member);
    client.users->assign(member.id, member.user);

    client->emit("guildMemberAdd", member, client);
  }

  void guildMemberRemove(mapping data) {
    Guild guild = restUtils->fetchCacheGuild(data.guild_id, client);
    if (!guild) return;

    User user = client.users->get(data.user.id);
    if (!user) user = User(client, data);

    // Remove from caching
    guild.members->delete(user.id);
    client.users->delete(user.id);

    client->emit("guildMemberRemove", guild, user, client);
  }

  void guildMemberUpdate(mapping data) {
    Guild guild = restUtils->fetchCacheGuild(data.guild_id, client);
    if (!guild) return;

    GuildMember cached = guild.members->get(data.user.id);
    if (!cached) return;

    GuildMember newMember = GuildMember(client, guild, data);
    MiscUtils()->fixNullables(newMember, cached);

    guild.members->assign(data.user.id, newMember);

    array diffs = MiscUtils()->mappingDiff(cached, newMember);
    client->emit("guildMemberUpdate", guild, newMember, cached, diffs, client);
  }

  // TODO:
  void guildMemberChunk(mapping data) {

  }

  void guildRoleCreate(mapping data) {
    Guild guild = restUtils->fetchCacheGuild(data.guild_id, client);
    if (!guild) return;

    guild.roles->assign(data.role.id, Role(client, guild, data.role));
    Role role = guild.roles->get(data.role.id);

    client->emit("guildRoleCreate", guild, role, client);
  }

  void guildRoleUpdate(mapping data) {

    Guild guild = restUtils->fetchCacheGuild(data.guild_id, client);
    if (!guild) return;

    Role cached = restUtils->fetchCacheRole(data.role.id, client, guild);
    if (!cached) return;

    Role newRole = Role(client, guild, data.role);
    MiscUtils()->fixNullables(newRole, cached);

    guild.roles->assign(data.role.id, newRole);

    array diffs = MiscUtils()->mappingDiff(cached, newRole);

    if (sizeof(diffs) != 0)
      client->emit("guildRoleUpdate", guild, newRole, cached, diffs, client);
  }

  void guildRoleDelete(mapping data) {
    Guild guild = restUtils->fetchCacheGuild(data.guild_id, client);
    if (!guild) return;

    Role deletedRole = restUtils->fetchCacheRole(data.role_id, client, guild);
    if (!deletedRole) return;
    guild.roles->delete(data.role_id);
    client->emit("guildRoleDelete", guild, deletedRole, client);
  }

  void messageCreate(mapping data) {
    mixed channel = client.channels->get(data.channel_id);

    Message theMessage = Message(client, data);

    // TODO: Have max_messages cache to every channel
    if (!theMessage.channel) return;
    theMessage.channel.messages->assign(theMessage.id, theMessage);
    theMessage.channel.lastMessageId = theMessage.id;

    client->emit("messageCreate", theMessage, client);

  }

  void messageUpdate(mapping data) {
    mixed channel = restUtils->fetchCacheChannel(data.channel_id, client);
    if (!channel) return;

    Message cached = channel.messages->get(data.id);
    if (!cached) return;

    Message newMessage = Message(client, data);
    MiscUtils()->fixNullables(newMessage, cached);
    channel.messages->assign(data.id, newMessage);

    array diffs = MiscUtils()->mappingDiff(cached, newMessage);
    if (sizeof(diffs) != 0)
      client->emit("messageUpdate", newMessage, cached, diffs, client);
  }

  void messageDelete(mapping data) {
    mixed channel = restUtils->fetchCacheChannel(data.channel_id, client);
    if (!channel) return;

    Message theMessage = channel.messages->get(data.id);
    if (!theMessage) return;

    channel.messages->delete(data.id);

    client->emit("messageDelete", theMessage, client);
  }

  // TODO after REST implementation
  void messageDeleteBulk(mapping data) {

  }

  // TODO: figure out the count
  void messageReactionAdd(mapping data) {
    mixed cachedChannel = client.channels->get(data.channel_id);
    if (!cachedChannel) return;

    Message cachedMessage = cachedChannel.messages->get(data.message_id);
    if (!cachedMessage) return;

    Reaction theReaction = cachedMessage.reactions->get(data.emoji.id);
    if (!theReaction) theReaction = Reaction(client, cachedMessage, data);

    cachedMessage.reactions->assign(theReaction.emoji.id, theReaction);
    theReaction.count++;

    client->emit("messageReactionAdd", theReaction, client);
  }

  void messageReactionRemove(mapping data) {
    mixed cachedChannel = client.channels->get(data.channel_id);
    if (!cachedChannel) return;

    Message cachedMessage = cachedChannel.messages->get(data.message_id);
    if (!cachedMessage) return;

    Reaction cachedReaction = cachedMessage.reactions->get(data.emoji.id);
    if (!cachedReaction) return;

    cachedReaction.count--;
    if (!cachedReaction.count)
      cachedMessage.reactions->delete(data.emoji.id);

    // Return message since cachedReaction can be deleted when it's count == 0
    client->emit("messageReactionRemove", cachedReaction, cachedMessage, client);
  }

  void messageReactionRemoveAll(mapping data) {
    mixed cachedChannel = client.channels->get(data.channel_id);
    if (!cachedChannel) return;

    Message cachedMessage = cachedChannel.messages->get(data.message_id);
    if (!cachedMessage) return;

    cachedMessage.reactions->reset();

    client->emit("messageReactionRemoveAll", cachedMessage, client);
  }

  /*
    NOTE: Presence update fires up in order to initialize
    newly cached member's presence, that's why for the first  "run"
    for each member, the difference count will be so high
  */
  void presenceUpdate(mapping data) {
    Guild guild = restUtils->fetchCacheGuild(data.guild_id, client);
    if (!guild) return;

    GuildMember cached = guild.members->get(data.user.id); // AUTO FETCH
    if (!cached) return;

    GuildMember newMember = GuildMember(client, guild, data);
    MiscUtils()->fixNullables(newMember, cached);
    guild.members->assign(data.user.id, newMember);
    newMember.presence = Presence(data);

    array diffs = MiscUtils()->mappingDiff(newMember.presence.game, cached.presence.game);
    if (sizeof(diffs) != 0)
      client->emit("presenceUpdate", newMember, cached, diffs, client);
  }

  void typingStart(mapping data) {
    mixed channel = restUtils->fetchCacheChannel(data.channel_id, client);
    if (!channel) return;

    User user = client.users->get(data.user_id);
    if (!user) return;

    client->emit("typingStart", user, channel, client);
  }

  void userUpdate(mapping data) {
    User cached = client.user;
    if (!cached) return; // Shouldn't happen lol

    User newUser = User(client, data);
    MiscUtils()->fixNullables(newUser, cached);

    array diffs = MiscUtils()->mappingDiff(newUser, cached);
    write("%O\n", diffs);
    if (sizeof(diffs) != 0)
      client->emit("userUpdate", newUser, cached, diffs, client);
  }
}
