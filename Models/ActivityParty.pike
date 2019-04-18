class ActivityParty {
  string id;
  array size;

  void create(mapping data) {
    id = data.id;
    size = data.size;
  }
}
