// include pike here

// We can use the client options in order to store more data in our client!
// Let's go ahead and add our settings as we set a property called commands
// It's type will be Gallon
// You can find more information about Gallon here:
// https://github.com/TheOnlyArtz/Fisher/blob/rest/Utils/Gallon.pike
int main() {
  Client client = Client("<token>");
  client.options["commands"] = Gallon(([]));

  client->login(); // Tell the client to establish a connection with Discord.

  client->handle("messageCreate", messageCreate); // Make the client to listen for that event.
  client->handle("ready", ready); // Make the client to listen for that event.
  return -1;
}

void ready(Client client) {
  write("The client is up and running!\n"); // Indicate to yourself that the client runs.

  // Now if you haven't did already, create a `commands` folder.
  // Fetch all of the file names from that directory
  array(string) commandFiles = get_dir("commands");
  foreach(commandFiles, string file) {
    // Now we will just go ahead and compile the file while
    // the command name will be it's file name!
    string commandName = file - ".pike";
    program command = compile_file("./commands/" + file);

    // If the command is valid, push if to the options["commands"] Gallon
    if (command.Command()->run) client.options["commands"]->assign(commandName, command.Command());
  }
}

void messageCreate(Message message, Client client) {
  string prefix = "!";
  if (message.author.bot || !has_prefix(message.content, prefix)) return;

  /* Start of argument parsing */
  array(string) arguments = (message.content  - prefix ) / " ";
  string command = arguments[0];
  arguments = Array.shift(arguments)[1];
  /* End of argument parsing */

  // Check if the command exists
  mixed commandClass = client.options["commands"]->get(command);

  // Don't forget to pass the parameters to run
  if (commandClass) commandClass->run(message, arguments, client);

  // Try to run !ping, it will work, enjoy!
}
