class RegionVoice {
  string id;
  string name;

  bool vip;
  bool optimal;
  bool deprecated;
  bool custom;

  Guild guild;
  void create(Client c, Guild g, mapping data) {
    guild = g;

    id = data.id;
    name = data.name;
    vip = data.vip;
    optimal = data.optimal;
    deprecated = data.deprecated;
    custom = data.custom;
  }
}
