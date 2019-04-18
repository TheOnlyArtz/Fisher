class Activity {
  string name;
  int type; // see activity type docs
  string url;
  ActivityTimestamps timestamps;
  string applicationId;
  string|Val.Null details;
  string|Val.Null state;
  ActivityParty party;
  ActivityAssets assests;
  ActivitySecrets secrets;

  bool instance;
  int flags;
}
