/**
* @param {string} id - The ID of the channel
* @param {int} type - the type of the channel
*/
class Channel {
  string id;
  int type;

  void create(mapping data) {
    id = data.id;
    type = data.type;
  }
}
