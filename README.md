### Fisher
- Fisher is a solution to interact with the Discord API using Pike
- Fisher is VERY new and mid development

#### Example usage v0.0.1
```pike
#include "Client.pike"

int main() {
  Client client = Client("TOKEN");
  client->login();
  client.handlers->ready = handleReady;

  return -1;
}

void handleReady(Client client) {
  write("==============\n");
  write("Connected as %s\n", client.user.username);
  write("ID: %s\n", client.user.id);
  write("Discriminator: %s\n", client.user.discriminator);
  write("Using Fisher v0.0.1");
}
```
