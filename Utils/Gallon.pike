/**
* Gallon is a data type which implements Mapping cores
* Why having a custom data type you ask?
* While Pike offers many useful features it lacks some important ones
* Gallon is here to sort many issues in order to make our lives easier!

* The name came from an idea that Pike is related to fish so that's mainly why name
* in the library will be called after related topic.
*/

class Gallon {
  inherit Mapping;

  mapping iterable;

  void create(mapping i) {
    iterable = i;
  }

  /**
  * Returns an array of the values the Gallon contains
  */
  array arrayOfValues() {
    return values(iterable);
  }

  /**
  * Returns an array of keys the gallon contains (known as indexes)
  */
  array arrayOfKeys() {
    return indices(iterable);
  }

  /**
  * A method to check if the Gallon contains a specific key
  * @param {string} key - The specific key to look for
  */
  bool has(string key) {
    return has_index(iterable, key);
  }

  /**
  * Returns the first element out of the Gallon
  */
  mixed first() {
    array keys = arrayOfKeys();
    return iterable[keys[0]];
  }

  /**
  * Returns the last element out of the Galllon
  */
  mixed last() {
    array keys = arrayOfKeys();
    return iterable[keys[-1]];
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
      if (iterable[key][property] == value) return key;
    }

    return Val.null;
  }
}
