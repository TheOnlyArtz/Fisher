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
    client.guilds->assign(guild.id, guild);
    client.cacher->cacheGuild(guild);
    // if (!alreadyInside)
      client.handlers->guildCreate(client, guild);
  }
}
