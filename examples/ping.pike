// include library here according to path

int main() {
  Client client = Client("<token>");
  client->login(); // Tell the client to establish a connection with Discord.

  client->handle("messageCreate", messageCreate); // Make the client to listen for that event.
  return -1;
}

void messageCreate(Message message, Client client) {
  if (message.author.bot) return; // Return for bots! (Please do.)

  // has_prefix (a native method) check whether a string starts with a ... prefix.
  if (has_prefix(message.content, "ping")) {
    // The interaction with the API is more "low level" in order to know what payloads to use
    // 1) https://github.com/TheOnlyArtz/FisherDocParser/blob/master/README.md#method-signatures-31
    // 2) https://discordapp.com/developers/docs/intro
    client.api->createMessage(message.channel.id, "PONG!");
  }
}
