// We will pass the next parameters in order for our bot to be able to do
// everything from this isolated file.
// For Fisher's own types we will use mixed since we can't have access
// to the actual types unless we include Fisher but that's just a big mess.
// we will only want to include Fisher in order to use utilities, like:
// EmbedConstructor to send embeds across the globe :) !
// Since Pike can only access classes when compiling an external file
// We will  go ahead and call our class `Command`
// And our executable function, `run`!
// If you won't modify the commandHandler to your favor it won't work otherwise.
class Command {
  void run(mixed message, array(string) arguments, mixed client) {
    client.api->createMessage(message.channel.id, "Pong!");
  }
}
