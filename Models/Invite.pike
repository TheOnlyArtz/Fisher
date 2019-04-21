class Invite {
  string code;
  Guild|Val.Null guild;
  mixed channel;
  User targetUser;
  int|Val.Null targetUserType;
  int|Val.Null approximatePresenceCount;
  int|Val.Null approximateMemberCount;

  void create(Client client, mapping data) {
    code = data.code;
    guild = client.guilds->get(data.guild.id) || data.guild;
    channel = guild && guild.channels->get(data.channel.id) ? guild.channels->get(data.channel.id) : data.channel;
    targetUser = client.users->get(data.user.id) || data.user;
    targetUserType = data.target_user_type || data.targetUserType;
    approximatePresenceCount = data.approximate_presence_count || data.approximatePresenceCount;
    approximateMemberCount = data.approximate_member_count || data.approximateMemberCount;  
  }
}
