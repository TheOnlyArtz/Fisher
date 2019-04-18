class ReactionEmoji {
  string|Val.Null id;
  string name;
  bool animated;
  Reaction reaction;

  protected Client client;
  void create(Client c, Reaction r, mapping data) {
    id = data.id;
    animated = data.animated;
    name = data.name;
    reaction = r;
  }
}
