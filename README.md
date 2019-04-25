## Fisher
- Fisher is a solution to interact with the Discord API using Pike
- Fisher is VERY new and mid development

## Installation
```
// Requirements
- git
- Pike v8.0 release 702+
```

First, we will open a new folder for our bot, now run the following:
```
git clone https://github.com/TheOnlyArtz/Fisher.git
```
This will clone the stable branch.
Now go ahead and make a new file named `name.pike` (it can be whatever you want).
Go ahead and `include` Fisher
```pike
#include "Fisher/index.pike"
```
Great! Now you have Fisher installed successfully and you can start using it.

## Updating
Updating is as easy as running `git pull` in Fisher's path!

#### Example usage v0.0.1
```pike
#include "pathToIndex.pike"

int main() {
  Client client = Client("TOKEN");
  client->login();
  client->handle("ready", handleReady);

  return -1;
  // This is very important, always return -1
  // otherwise the backend will shut close and the program won't work
}

void handleReady(Client client) {
  write("==============\n");
  write("Connected as %s\n", client.user.username);
  write("ID: %s\n", client.user.id);
  write("Discriminator: %s\n", client.user.discriminator);
  write("Using Fisher v0.0.1");
}
```

### Available Events
These are the available events and their declarations
For more info please check out [EventDispatcher.pike](https://github.com/TheOnlyArtz/Fisher/blob/master/Gateway/EventDispatcher.pike)

All of the events declarations on the backend will look like
```pike
void <eventName>(mapping data);
```

Events which fall under the "update" section will automatically be sent with
an array of what has been updated!

Events which fall under the "delete/add/update" section will be cached automatically.

Events which require cached data to be returned will not dispatch if the data is not cached.

**Events will be sent with additional client parameter to give access to the client's object and it will be the last parameter in the function, therefore, optional!**

### ready
This event will dispatch when the client's connection to the socket has been made and identified.
- when emitted:
```pike
void handleReady(Client client);
```

### guildCreate
This event will dispatch whenever the client will join a new guild, but!, in the backend the GUILD_CREATE will be treated on client startup in order to cache the relevant data.
it will be dispatched globally when the client will join a new guild only.

- when emitted:
```pike
void handleGuildCreate(Guild guild, Client client);
```

### guildUpdate
Introducing the diffs parameter which stands for **difference**
between the new version of the object and the older version of the object.

- when emitted:
```pike
void handleGuildUpdate(Guild newGuild, Guild oldGuild, Array diffs, Client client);
```

### guildDelete
- when emitted:
```pike
void handleGuildDelete(Guild guild, Client client);
```

### guildBanAdd
- when emitted:
```pike
void handleGuildBanAdd(Guild guild, User user, Client client);
```

### guildBanRemove
- when emitted:
```pike
void handleGuildBanRemove(Guild guild, User user, Client client);
```

### guildEmojiUpdate
- when emitted:
```pike
// Emoji.guild is a thing so don't worry about it
void handleGuildEmojiUpdate(Emoji newEmoji, Emoji cached, Array diffs, Client client);
```

### guildEmojiAdd
- when emitted:
```pike
// Emoji.guild is a thing so don't worry about it
void handleGuildEmojiAdd(Emoji newEmoji, Client client);
```

### guildEmojiRemove
- when emitted:
```pike
// Emoji.guild is a thing so don't worry about it
void handleGuildEmojiRemove(Emoji emoji, Client client);
```

### guildMemberAdd
- when emitted:
```pike
void handleGuildMemberAdd(GuildMember member, Client client);
```

### guildMemberRemove
- when emitted:
```pike
void handleGuildMemberRemove(Guild guild, User user, Client client);
```

### guildMemberUpdate
- when emitted:
```pike
void handleGuildMemberUpdate(Guild guild, GuildMember member, GuildMember cached, Array diffs, Client client);
```

### guildRoleCreate
- when emitted:
```pike
void handleRoleCreate(Guild guild, Role role, Client client);
```

### guildRoleUpdate
- when emitted:
```pike
void handleRoleDelete(Guild guild, Role newRole, Role cached, array diffs, Client client);
```

### guildRoleDelete
- when emitted:
```pike
void handleRoleDelete(Guild guild, Role deletedRole, Client client);
```

### channelCreate
- when emitted:
```pike
void handleChannelCreate(mixed channel, Client client);
```
### channelUpdate
```pike
void handleChannelUpdate(mixed newChannel, mixed cache, array diffs, Client client);
```

### channelDelete
```pike
void handleChannelDelete(mixed cached, Client client);
```

### channelPinsUpdate
```pike
void handleChannelPinsUpdate(mixed channel, Client client);
```

### guildIntegrationsUpdate
```pike
void handleGuildIntegrationsUpdate(Guild guild, Client client);
```

### messageCreate
- when emitted:
```pike
void handleMessageCreate(Message theMessage, Client client);
```

### messageUpdate
- when emitted:
```pike
void handleMessageUpdate(Message newMessage, Message cached, array diffs, Client client);
```

### messageDelete
- when emitted:
```pike
void handleMessageDelete(Message theMessage, Client client);
```

### messageReactionAdd
- when emitted:
```pike
// Reaction.message is a thing so don't worry about it.
void handleMessageReactionAdd(Reaction theReaction, Client client);
```

### messageReactionRemove
- when emitted:
```pike
void handleMessageReactionRemove(Reaction cachedReaction, Client client);
```

### messageReactionRemoveAll
- when emitted:
```pike
void handleMessageReactionRemoveAll(Message cachedMessage, Client client);
```

### presenceUpdate
- when emitted:
```pike
void handlePresenceUpdate(Member newMember, Member cached, array diffs, Client client);
```

### typingStart
- when emitted:
```pike
void handleTypingStart(User user, mixed channel, Client client);
```

### userUpdate
Can be a little bit tricky, this is only the client's (bot) update event.
- when emitted:
```pike
void handleUserUpdate(User newUser, User cached, array diffs, ClientUser client);
```
