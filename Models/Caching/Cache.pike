class Cache {
  TTLCache ttlCache;
  Gallon cache;
  Gallon desiredList;
  string cacheType;

  void create(TTLCache|void ttlList, string ctype) {
    ttlCache = ttlList;
    cache = Gallon(([]));
    cacheType = ctype;
    if (ttlCache) {
      desiredList = ttlList[ctype + "TTL"];
      desiredList->assign("cachedObject", cache);
    }
  }

  protected void addEntry(string key, string|void majorParameter) {
    mapping payload;
    if (majorParameter) {
      payload = ([
        "expires": time() + (10 * 60),
        cacheType: majorParameter
      ]);
    } else {
      payload = ([
        "expires": time() + (10 * 60)
      ]);
    }

    desiredList->assign(key, payload);
  }

  protected void resetEntry(string key) {
    mixed val = desiredList->get(key);
    if (!val) return;

    val["expires"] = time() + (10 * 60);
  }

  /**
  * Get the value of a key if being contained in the Galllon
  * @param {string} key - The key you are looking for
  */
  mixed get(string key) {
    if (ttlCache) resetEntry(key);
    return cache->get(key);
  }

  /**
  * Assign a value to an either new or old key
  */
  void assign(string key, mixed value, string|void majorParameter) {
    cache->assign(key, value);
    if (ttlCache) {
      addEntry(key, majorParameter);
      desiredList->assign("cachedObject", cache);
    }
  }
  /**
  * Returns an array of the values the Gallon contains
  */
  array arrayOfValues() {
    return values(cache.iterable);
  }

  /**
  * Returns an array of keys the gallon contains (known as indexes)
  */
  array arrayOfKeys() {
    return indices(cache.iterable);
  }

  /**
  * A method to check if the Gallon contains a specific key
  * @param {string} key - The specific key to look for
  */
  bool has(string key) {
    if (ttlCache) resetEntry(key);
    return has_index(cache.iterable, key);
  }

  /**
  * Returns the first element out of the Gallon
  */
  mixed first() {
    array keys = arrayOfKeys();
    if (!sizeof(keys)) return ([]);
    resetEntry(keys[0]);
    return cache->get(keys[0]);
  }

  /**
  * Returns the last element out of the Galllon
  */
  mixed last() {
    array keys = arrayOfKeys();
    if (!sizeof(keys)) return ([]);
    return cache->get(keys[-1]);
  }

  /**
  * This function will delete a key out of the Gallon
  * @param {string} key - The key to delete
  */
  void delete(string key) {
    m_delete(cache.iterable, key);
  }

  /**
  * This function erase the Gallon completely
  */
  void reset() {
    foreach(indices(cache.iterable), string key) {
      m_delete(cache.iterable, key);
    }
  }

  /*
  * This function will look for a specific value in a specific property
  * Out of all the elements the Gallon contains
  * Returns an array of keys which include the matching condition
  * EXAMPLE:
  * array keysMatching = guild.roles.lookFor("name", "theNameYou'reLookingFor");
  * if (keysMatching[0]) write("There's a role with that name!");
  */
  mixed lookFor(string property, mixed value) {
    array gallonKeys = arrayOfKeys();

    foreach (gallonKeys, mixed key) {
      if (ttlCache) resetEntry(key);
      if (cache->get(key)[property] == value) return cache->get(key);
    }

    return Val.null;
  }

  protected string _sprintf(int op) {
      if(op == 'O')
          return sprintf("%O", cache.iterable);
  }
}
