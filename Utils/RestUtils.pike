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

  string constructAttachmentUpload(string file, string name, bool content, string contentStr) {
    string CONTENT_TYPE = "Content-Type: application/octet-stream;";
    string CONTENT_DISPOS_ATTACH = sprintf("Content-Disposition: form-data; name=\"file\"; filename=\"%s\";", name);
    string CONTENT_DISPOS_CONTENT = sprintf("Content-Disposition: form-data; name=\"content\";");

    string start = sprintf("\r\n--main\r\n%s\r\n%s\r\n\r\n%s\r\n", CONTENT_TYPE,CONTENT_DISPOS_ATTACH,file);

    if (content) {
      string mid = sprintf("--main\r\n%s\r\n\r\n%s\r\n", CONTENT_DISPOS_CONTENT, contentStr);
      return start + mid + "--main--";
    }

    return start + "--main--";
  }

  /* Auto fetch section */
  Guild fetchCacheGuild(string guildId, Client client) {
    if (client.guilds->get(guildId)) return client.guilds->get(guildId);

    Guild g = client.api->getGuild(guildId);

    client.guilds.assign(guildId, g);
    return g;
  }
}
