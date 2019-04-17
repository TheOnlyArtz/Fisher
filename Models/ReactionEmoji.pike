class ReactionEmoji {
  string|Val.Null id;
  string identifier;
  string name;
  Reaction reaction;

  protected Client client;
  void create(Client c, Reaction r, mapping data) {
    id = data.id;
    identifier = data.identifier;
    name = data.name;
    reaction = r;
  }
}
