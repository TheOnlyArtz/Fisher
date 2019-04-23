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
  write(message.member.presence.game.name || "uncached\n");
  if (has_prefix(message.content, "myinfo")) {
    // Check https://github.com/theonlyartz/FisherDocParser/blob/master/README.md#EmbedConstructor
    EmbedConstructor embed = EmbedConstructor()
    ->assignTitle(sprintf("User info for: %s", message.author.username))
    ->assignThumbnail(sprintf("https://cdn.discordapp.com/avatars/%s/%s.png", message.author.id, message.author.avatar))
    ->addField("Username", message.author.username)
    ->addField("Discriminator", message.author.discriminator)
    ->addField("Status", message.member.presence.game.name || "uncached");
    // To send an embed you need to construct it calling _->construct();
    // When you don't want to fill up a voidable argument pass in UNDEFINED
    // Since it's a lower level API, you need to send embeds as an array of well.. embed objects
    mapping payload = ([
      "embed": embed->construct()
    ]);

    client.api->createMessage(message.channel.id, UNDEFINED, payload);
  }
}
