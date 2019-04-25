/**
* Used to help with guild caching related traffic
* - Emojis
* - Attachments
* - Members
* - Mentions (?)
* - Users
*/
class MessageCacher {
  void cacheReactions(Client client, Message message, array data) {
    if (!message.reactions || !data) return;
    Reaction reaction;
    for (int i = 0; i < sizeof(data); i++) {
      reaction = Reaction(client, message, data[i]);
      message.reactions->assign(data[i].id, reaction);
    }
  }

  void cacheMentions(Client client, Message message, array data) {
    if (!message.mentions || !data) return;
    mixed user;
    for (int i = 0; i < sizeof(data); i++) {
      user = message.guild ? RestUtils()->fetchCacheGuildMember(data[i].id, client, message.guild) : User(client, data[i]);
      message.mentions->assign(data[i].id, user);
    }
  }

  void cacheAttachments(Client client, Message message, array data) {
    if (!message.attachments || !data) return;
    for (int i = 0; i < sizeof(data); i++)
      message.attachments->assign(data[i].id, Attachment(client, data[i]));
  }

  // TODO: Embeds, not critical
}
