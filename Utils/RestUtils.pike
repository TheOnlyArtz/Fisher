class RestUtils {
  mixed getChannelAccordingToType(int type, mapping data, Client client, void|Guild g) {
    switch (type) {
      case 0:
        return GuildTextChannel(client, data, g);
        break;
      case 1:
        return ChannelDM(client, data);
        break;
      case 2:
        return ChannelVoice(client, data, g);
        break;
      case 4:
        return ChannelCategory(client, data, g);
        break;
    }
  }
}
