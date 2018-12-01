#include "Gateway/WSManager.pike"

class Client {
  string token;
  WSManager wsManager;
  Protocols.WebSocket.Connection ws;

  void create(string t) {
    token = t;
    wsManager = WSManager(this);
  }

  void login() {
    wsManager->start();
  }
}

int main() {
  Client client = Client("NDcxNjkzNjgyMzE2NDEwODgw.DuReww.7JTiq_jEr-7vrmpmWQWTzWJPNpM");
  client->login();

  return -1;
}
