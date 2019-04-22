class Permission {
  int allow;
  int deny;
  string type;
  string id;

  GuildMember|Role|Val.Null overwriteable;
  protected Client client;

  void create(Client client, mapping data, Guild|void guild) {
    allow = data.allow;
    deny = data.deny;
    type = data.type;
    id = data.id;

    if (!objectp(guild))
      return;
    else if (data.type == "role")
      overwriteable = RestUtils()->fetchCacheRole(data.id, client, guild);
    else if (data.type == "member")
      overwriteable = guild.members->get(data.id);
  }
}
