class Snowflake {
  int EPOCH = 1420070400000;

  mapping extractData(string id) {
    int snowflake = (int) id;

    int whenCreated = (snowflake >> 22) + EPOCH;
    int processID = (snowflake & 0x1F000) >> 22;
    int workerID = (snowflake & 0x3E0000) >> 17;
    int increment = snowflake & 0xFFF;

    return ([
        "whenCreated": (string) whenCreated,
        "processID": processID,
        "workerID": workerID,
        "increment": increment
    ]);
  }
}
