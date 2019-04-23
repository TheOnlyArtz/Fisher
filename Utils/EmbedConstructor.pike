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

  this_program assignFooter(string text, string|void iconUrl, string|void proxyIconUrl) {
    footer = ([
      "text": text || Val.null,
      "icon_url": iconUrl || Val.null,
      "proxy_icon_url": proxyIconUrl || Val.null
    ]);

    return this;
  }

  this_program assignImage(string|void url, string|void proxyUrl, int|void height, int|void width) {
    image = ([
      "url": url || Val.null,
      "proxy_url": proxyUrl || Val.null,
      "height": height || Val.null,
      "width": width || Val.null
    ]);

    return this;
  }

  this_program assignVideo(string|void url, int|void height, int|void width) {
    video = ([
      "url": url || Val.null,
      "height": height || Val.null,
      "width": width || Val.null
    ]);

    return this;
  }

  this_program assignThumbnail(string|void url, string|void proxyUrl, int|void height, int|void width) {
    thumbnail = ([
      "url": url || Val.null,
      "proxy_url": proxyUrl || Val.null,
      "height": height || Val.null,
      "width": width || Val.null
    ]);

    return this;
  }

  this_program assignProvider(string|void name, string|void url) {
    provider = ([
      "name": name,
      "url": url
    ]);

    return this;
  }

  this_program assignAuthor(string|void name, string|void url, string|void iconUrl, string|void proxyIconUrl) {
    author = ([
      "name": name || Val.null,
      "url": url || Val.null,
      "icon_url": iconUrl || Val.null,
      "proxy_icon_url": proxyIconUrl || Val.null
    ]);

    return this;
  }

  this_program addField(string name, string value, bool|void isInline) {
    if (sizeof(fields || ({})) == 25) throw("Can't set more than 25 fields in a single embed!");
    mapping payload = ([
      "name": name,
      "value": value,
      "inline": isInline ? Val.true : Val.false
    ]);

    fields = Array.push(fields || ({}), payload);

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
