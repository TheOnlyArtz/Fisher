class RestUtils {
  mixed getChannelAccordingToType(int type, mapping data, Client client) {
    switch (type) {
      case 0:
        return GuildTextChannel(client, data);
        break;
      case 1:
        return ChannelDM(client, data);
        break;
      case 2:
        return ChannelVoice(client, data);
        break;
      case 4:
        return ChannelCategory(client, data);
        break;
    }
  }
}
