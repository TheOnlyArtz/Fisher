class Attachment {
  string id;
  string filename;
  int size;
  string url;
  string proxyUrl;
  int|Val.Null height;
  int|Val.Null width;

  protected Client client;

  void create(Client c, mapping data) {
    client = c;

    id = data.id;
    filename = data.filename;
    size = data.size;
    url = data.url;
    proxyUrl = data.proxy_url || data.proxyUrl;
    height = data.height;
    width = data.width;
  }
}
