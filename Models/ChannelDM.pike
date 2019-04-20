class ChannelDM {
  string lastMessageId;
  int type;
  string id;
  Gallon recipients;
  Gallon messages;
  
  void create(Client c, mapping data) {
    lastMessageId = data.last_message_id || data.lastMessageId;
    type = data.type;
    id = data.id;
    messages = Gallon(([]));
    recipients = Gallon(([]));

    foreach(data.recipients, mapping recData) {
      recipients->assign(data.id, User(c, data));
    }
  }
}
