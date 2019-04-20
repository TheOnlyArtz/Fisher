class PermissionUtils {

  object constants = Constants();
  Gallon permissions_bits = constants.permissions_bits;
  int ADMINISTRATOR = permissions_bits->get("ADMINISTRATOR");

  int own(int permissions, string|int perm) {
    if (stringp(perm))
      perm = permissions_bits->get(perm);

    if (!perm) throw( ({constants.errorMsgs->get("UNKNOWN_PERM_NAME"), backtrace()}) );

    if ((permissions & ADMINISTRATOR) == ADMINISTRATOR || (permissions & perm) == perm) {
      return true;
    }

    return false;
  }

  int add(int permissions, array permsToOverwrite) {
    int bits = 0;
    int perm = 0;
    for (int i = 0; i < sizeof(permsToOverwrite); i++) {
      perm = permsToOverwrite[i];
      if(stringp(permsToOverwrite[i])) {
        perm = permissions_bits->get(permsToOverwrite[i]);
        if (!perm) throw ( ({constants.errorMsgs->get("UNKNOWN_PERM_NAME"), backtrace()}) );
      }
      bits |= perm;
    }

    return permissions | bits;
  }

  int remove(int permissions, array permsToOverwrite) {
    int bits = permissions;
    int perm = 0;
    for (int i = 0; i < sizeof(permsToOverwrite); i++) {
      perm = permsToOverwrite[i];
      if (stringp(permsToOverwrite[i])) {
        perm = permissions_bits->get(permsToOverwrite[i]);
        if (!perm) throw ( ({constants.errorMsgs->get("UNKNOWN_PERM_NAME"), backtrace()}) );
      }
      bits &= ~(perm);
    }
    return bits;
  }
}
