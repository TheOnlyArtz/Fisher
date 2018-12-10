class Attachment {
  string id;
  string filename;
  int size;
  string url;
  string proxy_url;
  int|Val.Null height;
  int|Val.Null width;

  protected Client client;

  void create(Client c, mapping data) {
    client = c;
    
    id = data.id;
    filename = data.filename;
    size = data.size;
    url = data.url;
    proxy_url = data.proxy_url;
    height = data.height;
    width = data.width;
  }
}
