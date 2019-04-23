class Presence {
  Activity|Val.Null game;
  string|int status;

  void create(mapping data) {
    game = sizeof(data.activities) ? Activity(data.activities[0]) : Activity((["name":""]));
    status = data.status || 0;
  }
}
