class Activity {
  string name;
  int type; // see activity type docs
  string url;
  ActivityTimestamps timestamps;
  string applicationId;
  string|Val.Null details;
  string|Val.Null state;
  ActivityParty|Val.Null party;
  ActivityAssets|Val.Null assets;
  ActivitySecrets|Val.Null secrets;

  bool instance;
  int flags;

  void create(mapping data) {
    name = data.name;
    type = data.type;
    url = data.url;
    timestamps = data.timestamps ? ActivityTimestamps(data.timestamps) : ({});
    details = data.details;
    state = data.state;
    party = data.party ? ActivityParty(data.party) : Val.null;
    assets = data.assets ? ActivityAssets(data.assets) : Val.null;
    secrets = data.secrets ? ActivitySecrets(data.secrets) : Val.null;
    instance = data.instance;
    flags = data.flags;
  }
}
