class Invite {
  string code;
  Guild|Val.Null guild;
  mixed channel;
  User|Val.Null targetUser;
  int|Val.Null targetUserType;
  int|Val.Null approximatePresenceCount;
  int|Val.Null approximateMemberCount;

  User inviter;
  int uses;
  int maxUses;
  int maxAge;
  bool temporary;
  string createdAt;
  bool revoked;

  void create(Client client, mapping data) {
    code = data.code;
    guild = client.guilds->get(data.guild.id) || data.guild;
    channel = guild && guild.channels->get(data.channel.id) ? guild.channels->get(data.channel.id) : data.channel;
    targetUser = data.target_user ? client.users->get(data.target_user.id) || data.target_user : Val.null;
    targetUserType = data.target_user_type || data.targetUserType || Val.null;
    approximatePresenceCount = data.approximate_presence_count || data.approximatePresenceCount || Val.null;
    approximateMemberCount = data.approximate_member_count || data.approximateMemberCount || Val.null;

    inviter = client.users->get(data.inviter.id) || User(client, data.inviter);
    uses = data.uses;
    maxUses = data.max_uses || data.maxUses;
    maxAge = data.max_age || data.maxAge;
    temporary = data.temporary;
    createdAt = data.created_at || data.createdAt;
    revoked = data.revoked;
  }
}
