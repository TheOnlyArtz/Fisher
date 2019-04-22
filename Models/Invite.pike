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
    guild = RestUtils()->fetchCacheGuild(data.guild.id, client) || data.guild;
    channel = guild ? RestUtils()->fetchCacheChannel(data.channel.id, client) : data.channel;
    targetUser = data.target_user ? RestUtils()->fetchCacheUser(data.target_user.id, client) : Val.null;
    targetUserType = data.target_user_type || data.targetUserType || Val.null;
    approximatePresenceCount = data.approximate_presence_count || data.approximatePresenceCount || Val.null;
    approximateMemberCount = data.approximate_member_count || data.approximateMemberCount || Val.null;

    inviter = RestUtils()->fetchCacheUser(data.inviter.id, client) || User(client, data.inviter);
    uses = data.uses;
    maxUses = data.max_uses || data.maxUses;
    maxAge = data.max_age || data.maxAge;
    temporary = data.temporary;
    createdAt = data.created_at || data.createdAt;
    revoked = data.revoked;
  }
}
