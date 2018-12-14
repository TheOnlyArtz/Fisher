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
  void handleReadyEvent(mapping data) {
    client.user = ClientUser(client, data.user);

    wsHandler.wsManager.wsSessionID = data.session_id;

    // Emit the event
    client.handlers->ready(client);

    // Start heartbeating
    wsHandler.wsManager->heartbeat(wsHandler.wsManager.heartbeat_interval/1000);
  }

  /**
   * handles the GUILD_CREATE event
   * @param {mapping} data
   */
  void handleGuildCreateEvent(mapping data) {
    Guild guild = Guild(client, data);
    bool alreadyInside = client.guilds->get(data.id);

    guildCacher->cacheMembers(guild, data.members);
    guildCacher->cacheChannels(guild, data.channels);
    guildCacher->cacheRoles(guild, data.roles);
    guildCacher->cacheEmojis(guild, data.emojis);
    client.cacher->cacheGuild(guild);

    if (!alreadyInside)
      client.handlers->guildCreate(client, guild);
  }

  void handleGuildUpdateEvent(mapping data) {
    Guild oldGuild = client.guilds->get(data.id);
    Guild newGuild = Guild(client, data);

    guildCacher->cacheRoles(newGuild, data.roles);
    guildCacher->cacheEmojis(newGuild, data.emojis);
    client.cacher->cacheGuild(newGuild);

    client.handlers->guildUpdate(client, newGuild, oldGuild);

  }

  void handleGuildDeleteEvent(mapping data) {

  }

  void handleGuildBanAddEvent(mapping data) {
    Guild guild = client.guilds->get(data.guild_id);
    User user = client.users->get(data.user.id) ? client.users->get(data.user.id) : User(client, data.user);

    if (client.users->get(data.user.id))
      client.users->delete(data.user.id);

    if (guild.members->get(data.user.id))
      guild.members->delete(data.user.id);

    if (guild)
      client.handlers->guildBanAdd(client, guild, user);
  }

  void handleGuildBanRemoveEvent(mapping data) {
    Guild guild = client.guilds->get(data.guild_id);
    User user = User(client, data.user);

    if (guild)
      client.handlers->guildBanRemove(guild, user, client);
  }

  void handleGuildEmojisUpdateEvent(mapping data) {
    Guild guild = client.guilds->get(data.guild_id);

    if (!guild || !guild.emojis) return;

    foreach(data.emojis, mapping emoji) {
      Emoji cached = guild.emojis->get(emoji.id);

      if (cached) {
        Emoji newEmoji = Emoji(client, guild, emoji);
        array diffs = MiscUtils()->mappingDiff(cached, newEmoji);

        if (sizeof(diffs) > 0) {
          // Emit guildEmojisUpdate
          client.handlers->guildEmojiUpdate(guild, newEmoji, cached, diffs, client);
        }
      }
    }

  }
}
