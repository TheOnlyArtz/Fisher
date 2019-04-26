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
    else if (data.type == "role") {
      RestUtils()->fetchCacheRoles(data.id, client, guild);
      overwriteable = guild.roles->get(data.id);
    }
    else if (data.type == "member")
      overwriteable = RestUtils()->fetchCacheGuildMember(data.id, client, guild);
  }
}
