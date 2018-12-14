class MiscUtils {
  array equal(mapping a, mapping b) {
    array difference = ({});
    array indicesA = indices(a);
    array indicesB = indices(b);

    foreach(indicesA, string key) {
      mixed valueA = a[key];
      mixed valueB = b[key];

      if (valueA != valueB) {
        difference = Array.push(difference, key);
      }
    }

    foreach(indicesB, string key) {
      mixed valueA = a[key];
      mixed valueB = b[key];

      if (valueA != valueB) {
        difference = Array.push(difference, key);
      }
    }

    // Return difference array without duplicate values
    return Array.uniq(difference);
  }
}
