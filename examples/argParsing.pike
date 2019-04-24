// include library here according to path

int main() {
  Client client = Client("<token>");
  client->login();

  client->handle("messageCreate", messageCreate);
  return -1;
}

void messageCreate(Message message, Client client) {
  string prefix = "!";
  if (message.author.bot || !has_prefix(message.content, prefix)) return; // Return for bots! (Please do.)
  array(string) arguments = (message.content  - prefix )/ " "; // This will return an array of strings accordingly
  string command = arguments[0];
  arguments = Array.shift(arguments)[1];
  // Pop the first elements (the command)
  string argumentsAsString = arguments * " "; // This will return a string joined by \s
  if (command == "say") {
    if (!sizeof(argumentsAsString))
      return client.api->createMessage(message.channel.id, "Arguments are required!");

    client.api->createMessage(message.channel.id, argumentsAsString);
  } else if (command == "bulkdelete") {
    // We don't want more than a single word so we will pick arguments since it's an array
    if (!sizeof(arguments))
      return client.api->createMessage(message.channel.id, "Arguments are required, `2 - 100`!");

    int messageAmount = (int) arguments[0];
    if (messageAmount < 2 || messageAmount > 100)
      return client.api->createMessage(message.channel.id, "The limit is `2 - 100` messages!");
    // Delete the bot's message first so the number of deleted message will be accurate.
    client.api->deleteMessage(message.channel.id, message.id);

    // Since arguments is an array of strings we have to cast it to int.
    client.api->bulkDeleteMessages(message.channel.id, (int) arguments[0]);
    client.api->createMessage(message.channel.id, sprintf("Deleted %d messages :)", (int) arguments[0]));
  }
}
