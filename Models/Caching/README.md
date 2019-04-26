# Auto caching system for Fisher
### Features:
- A default of 10 minutes cache
- Every cache "touch" the expired time will get resetted
- A whole new Client.Cache structure which will include:
	- guilds:
		- channels:
			- messages? :
		- members:
			- presences
		- emojis
		- roles
### Structure:
- The structure itself will be a model (Client.Cache) which will be placed on the Client's memory wise.
- The auto caching will be **optional** which means that the model should be built in considiration of this fact.
- To get a value from a certain cache the model will first return the value from the cache and **only then update it's expiry**
- In order to be even more memory efficient the model will only run one instance of disposal for each possible property, e.g the messages disposal:
```c
([
	"messageId": ([
		"expires": "unixTimestamp",
		"channelId": "id"
	]),
	"secondMessageId": ([
		"expires": "unixTimestamp",
		"channelId": "id"
	])
]); // Note for handling messages, "explode" all of the messages from a certain channelId
// If the desired channel has been deleted.
// Same will apply for presences and sub-caches in general.
```
### Syntax:
```c
Client.Cache.guilds->get("key");
Client.Cache.members->get("key");
mixed channel = Client.Cache.channels->get("key");
channel.messages("key"); // Still using the same model!
```
