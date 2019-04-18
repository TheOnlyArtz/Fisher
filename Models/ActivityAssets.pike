class ActivityAssets {
  string largeImage;
  string largeText;
  string smallImage;
  string smallText;

  void create(mapping data) {
    largeImage = data.large_image;
    largeText = data.large_text;
    smallImage = data.small_image;
    smallText = data.small_text;
  }
}
