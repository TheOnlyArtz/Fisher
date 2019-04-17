/**
* The Guild class houses all of the Guild functions and properties
* @param {string} id - The guild's ID
* @param {string} name - The guild's name
* @param {string|Val.Null} icon - The guild's icon hash
* @param {string|Val.Null} splash - The guild's splash has
* @param {string} owner_id - The guild's owner ID
* @param {bool} owner - Whether or not the user is the owner of the guild
* @param {int} permissions - The user's permissions
* @param {string} region - Voice region ID for the guild
* @param {string|Val.Null} afk_channel_id - ID of afk channel
* @param {int} afk_timeout - afk timeout in SECONDS
* @param {bool} embed_enabled - Is this guild embeddable (e.g widget)
* @param {string|Val.Null} embed_channel_id - The channel ID that the widget will generate an invite to
* @param {int} verification_level - verification level required for the guild
* @param {int} default_message_notifications - default message notifications level
* @param {int} explicit_content_filter - Explicit content filter level
* @param {mapping} roles - Roles in the guild
* @param {mapping} emojis - Custom guild emojis
* @param {array(string)} features - Enabled guild features
* @param {int} mfa_level - Required MFA level for the guild
* param {string|Val.Null} application_id - Application id of the guild creator if it's bot-created
* @param {bool} widget_enabled - Whether or not the server widget is enabled
* @param {string} widget_channel_id - The channel ID for server widget
* @param {string|Val.Null} system_channel_id - The ID of the channel to which system messages are sent
* @param {mixed} joined_at - When this guild was joined at
* @param {bool} large - Whether this is considered a large guild
* @param {bool} unavailable - Whether the guild is unavailable
* @param {int} member_count - Total number of members in this guild
* @param {mapping} voice_states - partial voice states in the guild
* @param {mapping} members - users in the guild
* @param {mapping} channels - Channels in the guild
* @param {mapping} presences - Presences of users in the guild.
*/
class Guild {
  string id;
  string name;
  string ownerId;
  string region;
  string widgetChannelId;
  string joined_at;

  string|Val.Null icon;
  string|Val.Null splash;
  string|Val.Null afkChannelId;
  string|Val.Null embedChannelId;
  string|Val.Null applicationId;
  string|Val.Null systemChannelId;
  string|Val.Null banner;
  string|Val.Null description;
  string|Val.Null vanityUrlCode;
  int|Val.Null maxPresences;

  bool embedEnabled;
  bool owner;
  bool widgetEnabled;
  bool large;
  bool unavailable;

  int permissions;
  int afkTimeout;
  int verificationLevel;
  int defaultMessageNotifications;
  int mfaLevel;
  int explicitContentFilter;
  int memberCount;
  int maxMembers;

  Gallon roles;
  Gallon emojis;
  Gallon voiceStates;
  Gallon members;
  Gallon channels;
  Gallon presences;

  array(string) features;

  protected Client client;

  /**
  * The constructor
  * @param {mapping} data - The guild data
  * @param {Client} client - The client
  */
  void create(Client c, mapping data) {
    id = data.id;
    name = data.name;
    icon = data.icon;
    splash = data.splash;
    owner = data.owner;
    ownerId = data.owner_id || data.ownerId;
    permissions = data.permissions;
    region = data.region;
    afkChannelId = data.afk_channel_id || data.afkChannelId;
    afkTimeout = data.afk_timeout || data.afkTimeout;
    embedEnabled = data.embed_enabled || data.embedEnabled;
    embedChannelId = data.embed_channel_id || data.embedChannelId;
    verificationLevel = data.verification_level || data.verificationLevel;
    defaultMessageNotifications = data.default_message_notifications || data.defaultMessageNotifications;
    explicitContentFilter = data.explicit_content_filter || data.explicitContentFilter;
    roles = Gallon(([]));
    emojis = Gallon(([]));
    voice_states = Gallon(([]));
    members = Gallon(([]));
    channels = Gallon(([]));
    presences = Gallon(([]));

    features = data.features;

    mfaLevel = data.mfa_level;
    applicationId = data.application_id || data.applicationId;
    widgetEnabled = data.widget_enabled || data.widgetEnabled;
    widgetChannelId = data.widget_channel_id || data.widgetChannelId;
    systemChannelId = data.system_channel_id || data.systemChannelId;
    joinedAt = data.joined_at || data.joinedAt;
    large = data.large;
    memberCount = data.member_count || data.memberCount;
    banner = data.banner;
    description = data.description;
    vanityUrlCode = data.vanity_url_code || data.vanityUrlCode;
    maxPresences = data.max_presences || data.maxPresences;

    client = c;
  }
}
