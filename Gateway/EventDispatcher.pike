#include "../Models/Caching/GuildCacher.pike"
// MODELS:
/** READY EVENT */
#include "../Models/ClientUser.pike"

/** GUILD_CREATE EVENT */
#include "../Models/Guild.pike"

/**
 * Here all the events with OP code 0 will be handled!
 * @property {WSHandler} wsHandler - The websocket handler
 * @param {Client} client - The client.
 */
class EventDispatcher {
  WSHandler wsHandler;
  Client client;

  GuildCacher guildCacher = GuildCacher();
  /**
  * The constructor
  */
  void create(WSHandler w) {
    wsHandler = w;
    client = w.client;
  }

  /**
   * handles the READY event
   * @param {mapping} data
   */
  void handleReadyEvent(mapping data) {
    client.user = ClientUser(client, data.user);

    foreach(data.guilds, mapping guild) {
      client.guilds[guild.id] = guild;
    }

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
    bool alreadyInside = client.guilds[data.id];

    client.guilds[guild.id] = guild;
    guildCacher->cacheMembers(client, guild, data.members);
    write("%O", data.channels);

    // if (!alreadyInside)
      client.handlers->guild_create(client, guild);
  }
}
