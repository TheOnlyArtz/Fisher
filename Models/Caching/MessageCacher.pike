/**
* Used to help with guild caching related traffic
* - Emojis
* - Attachments
* - Members
* - Mentions (?)
* - Users
*/
class MessageCacher {
  void cacheReactions(Client client, Message message, mapping data) {
    // TODO: Create a reaction model
  }

  void cacheMentions(Client client, Message message, array data) {
    for (int i = 0; i < sizeof(data); i++) {
      GuildMember user = message.guild ? GuildMember(client, message.guild, data[i]) : User(client, data[i]);
      message.mentions->assign(data[i].id, user);
    }
  }

  void cacheAttachments(Client client, Message message, array data) {
    for (int i = 0; i < sizeof(data); i++)
      message.attachments->assign(data[i].id, Attachment(client, data[i]));
  }

  // TODO: Embeds, not critical
}
