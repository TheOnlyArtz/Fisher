class GuildIntegration {
  string id;
  string name;
  string type;
  bool enabled;
  bool syncing;
  string roleId;
  Role role;
  int expireBehavior;
  int expireGracePeriod;
  User user;
  mapping account;
  string syncedAt;

  void create(Client client, mapping data) {
    id = data.id;
    type = data.type;
    enabled = data.enabled;
    syncing = data.syncing;
    roleId = data.role_id || data.roleId;
    expireBehavior = data.expire_behavior || data.expireBehavior;
    user = User(client, data.user);
    account = data.account;
    syncedAt = data.synced_at || data.syncedAt;
  }
}
