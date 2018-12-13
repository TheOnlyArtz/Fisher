/**
 * The event handlers callbacks go in here
 * @property {function} ready - The READY event handler
 * @property {function} guild_create - The GUILD_CREATE event handler
 */
class EventHandlers {
  function ready;
  function guildCreate;

  void create() {
    ready = lambda() {};
    guildCreate = lambda() {};
  }
}
