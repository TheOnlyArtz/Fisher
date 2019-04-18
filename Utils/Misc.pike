// TODO: Maybe commit it to the PikeLang stdlib
class MiscUtils {
  mapping clonedData;

  array mappingDiff(mapping|object a, mapping|object b) {
    array difference = ({});
    array indicesA = indices(a);
    array indicesB = indices(b);

    foreach(indicesA, string key) {
      mixed valueA = a[key];
      mixed valueB = b[key];

      if (functionp(valueA) || functionp(valueB)) continue;
      if (!equal(valueA, valueB)) {
        difference = Array.push(difference, key);
      }
    }

    foreach(indicesB, string key) {
      mixed valueA = a[key];
      mixed valueB = b[key];

      if (functionp(valueA) || functionp(valueB)) continue;
      if (!equal(valueA, valueB)) {
        difference = Array.push(difference, key);
      }
    }

    // Return difference array without duplicate values
    return Array.uniq(difference);
  }

  mixed cloneObject(mixed Instance, mixed data, mixed ... args) {
    mixed instance = Instance(@args, data);
    array instanceIndices = indices(instance);
    foreach(instanceIndices, string key) {
      if (data[key] && !functionp(data[key])) {
        if (!(function_name(object_program(instance[key])) == "Gallon"))
          instance[key] = data[key];
          // write("%O\n", key);
      }
    }

    return instance;
  }

  void fixNullables(mixed instance, mixed data) {
    bool first;
    bool second;
    foreach(indices(instance), string key) {
      first = (data[key] || basetype(data[key]) == "object");
      second = (instance[key] == 0 || instance[key] == Val.null);
      if (first && second) {
        instance[key] = data[key];
      }
    }
  }
}
