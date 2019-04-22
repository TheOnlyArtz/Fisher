class EmbedConstructor {
  string|Val.Null title;
  string|Val.Null type;
  string|Val.Null description;
  string|Val.Null url;
  string|Val.Null timestamp;
  int|Val.Null color;
  mapping|Val.Null footer;
  mapping|Val.Null image;
  mapping|Val.Null thumbnail;
  mapping|Val.Null video;
  mapping|Val.Null provider;
  mapping|Val.Null author;
  array|Val.Null fields;

  void create() {
    
  }

  this_program assignTitle(string t) {
    title = t;
    return this;
  }

  this_program assignType(string t) {
    type = t;
    return this;
  }

  this_program assignDescription(string d) {
    description = d;
    return this;
  }

  this_program assignURL(string u) {
    url = u;
    return this;
  }

  this_program assignTimestamp(string t) {
    timestamp = t;
    return this;
  }

  this_program assignColor(int c) {
    color = c;
    return this;
  }

  this_program assignFooter(mapping f) {
    footer = f;
    return this;
  }

  this_program assignImage(mapping i) {
    image = i;
    return this;
  }

  this_program assignVideo(mapping v) {
    video = v;
    return this;
  }

  this_program assignThumbnail(mapping t) {
    thumbnail = t;
    return this;
  }

  this_program assignProvider(mapping p) {
    provider = p;
    return this;
  }

  this_program assignAuthor(mapping a) {
    author = a;
    return this;
  }

  this_program addField(mapping f) {
    if (sizeof(fields) == 25) throw("Can't set more than 25 fields in a single embed!");
    fields = Array.push(fields || ({}), f);
    return this;
  }

  mapping construct() {
    return ([
      "title": title || Val.null,
      "type": type || Val.null,
      "description": description || Val.null,
      "url": url || Val.null,
      "timestamp": timestamp || Val.null,
      "color": color || Val.null,
      "footer": footer || Val.null,
      "image": image || Val.null,
      "thumbnail": thumbnail || Val.null,
      "video": video || Val.null,
      "provider": provider || Val.null,
      "author": author || Val.null,
      "fields": fields || Val.null
    ]);
  }
}
