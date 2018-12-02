/**
* The Guild class houses all of the Guild functions and properties
* @param {string} id - The guild's ID
* @param {string} name - The guild's name
* @param {string|null} icon - The guild's icon hash
* @param {string|null} splash - The guild's splash has
* @param {string} owner_id - The guild's owner ID
* @param {bool} owner - Whether or not the user is the owner of the guild
* @param {int} permissions - The user's permissions
* @param {string} region - Voice region ID for the guild
* @param {string} afk_channel_id - ID of afk channel
* @param {int} afk_timeout - afk timeout in SECONDS
* @param {bool} embed_enabled - Is this guild embeddable (e.g widget)
* @param {string} embed_channel_id - The channel ID that the widget will generate an invite to
* @param {int} verification_level - verification level required for the guild
* @param {int} default_message_notifications - default message notifications level
* @param {int} explicit_content_filter - Explicit content filter level
* @param {mapping} roles - Roles in the guild
* @param {mapping} emojis - Custom guild emojis
* @param {array(string)} features - Enabled guild features
* @param {int} mfa_level - Required MFA level for the guild
* param {string} application_id - Application id of the guild creator if it's bot-created
* @param {bool} widget_enabled - Whether or not the server widget is enabled
* @param {string} widget_channel_id - The channel ID for server widget
* @param {string} system_channel_id - The ID of the channel to which system messages are sent
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
  string|null icon;
  string|null splash;
  bool owner;
  string owner_id;
  int client_permissions;
  string region;
  string|null afk_channel_id;
  int afk_timeout;
  bool embed_enabled;
  string|null embed_channel_id;
  int verification_level;
  int default_message_notifications;
  int explicit_content_filter;

  mapping roles;
  mapping emojis;
  mapping voice_states;
  mapping members;
  mapping channels;
  mapping presences;

  array(string) features;

  int mfa_level;
  string|null application_id;
  bool widget_enabled;
  string widget_channel_id;
  string|null system_channel_id;
  mixed joined_at // CHECK WHAT FORMAT IT IS (SHOULD BE ISO8601)
  bool large;
  bool unavailable;
  int member_count;

  /**
  * The constructor
  * @param {mapping} data - The guild data
  */
  void create(mapping data) {
    id = data.id;
    name = data.name;
    icon = data.icon;
    splash = data.splash;
    owner = data.owner;
    owner_id = data.owner_id;
    client_permissions = data.permissions;
    region = data.region;
    afk_channel_id = data.afk_channel_id;
    afk_timeout = data.afk_timeout;
    embed_enabled = data.embed_enabled;
    embed_channel_id = data.embed_channel_id;
    verification_level = data.verification_level;
    default_message_notifications = data.default_message_notifications;
    explicit_content_filter = data.explicit_content_filter;
    roles = data.roles;
    emojis = data.emojis;
    voice_states = data.voice_states;
    members = data.members;
    channels = data.channels;
    presences = data.presences;

    features = data.features;

    mfa_level = data.mfa_level;
    application_id = data.application_id;
    widget_enabled = data.widget_enabled;
    widget_channel_id = data.widget_channel_id;
    system_channel_id = data.system_channel_id;
    joined_at = data.joined_at;
    large = data.large;
    member_count = data.member_count;
  }
}