import 'package:cmp/models/role.dart';
import 'package:flutter/foundation.dart';

class RoleProvider extends ChangeNotifier {
  Role role;

  RoleProvider() {
    this.role = Role(ROLE.MEMBER, false);
  }

  void setRole(Role pRole) {
    this.role = pRole;
    notifyListeners();
  }
}
