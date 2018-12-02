/**
* The event handlers callbacks go in here
* @property {function} ready - The READY event handler
* @property {function} guild_create - The GUILD_CREATE event handler
*/
class EventHandlers {
  function ready;
  function guild_create;

  void create() {
    ready = lambda() {};
    guild_create = lambda() {}
  }
}
