class ActivitySecrets {
  string join;
  string spectate;
  string match;

  void create(mapping data) {
    join = data.join;
    spectate = data.spectate;
    match = data.match;
  }
}
