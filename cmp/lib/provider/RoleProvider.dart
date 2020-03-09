import 'package:cmp/models/role.dart';
import 'package:flutter/foundation.dart';

class RoleProvider extends ChangeNotifier {
  Role _role;

  RoleProvider() {
    this._role = Role(ROLE.MEMBER, false);
  }

  void setRole(Role pRole) {
    this._role = pRole;
    notifyListeners();
  }

  Role get role {
    return this._role;
  }
}
