import 'package:flutter/material.dart';

enum ROLE {
  MEMBER,
  ADMIN,
  MASTER,
}

class Role {
  ROLE _role;

  Role(ROLE pRole) {
    this._role = pRole;
  }
  Role.fromFirebase(Map pMap) {
    switch (pMap['key']) {
      case 'ROLE.MEMBER':
        this._role = ROLE.MEMBER;
        break;
      case 'ROLE.ADMIN':
        this._role = ROLE.ADMIN;
        break;
      case 'ROLE.MASTER':
        this._role = ROLE.MASTER;
        break;
    }
  }

  Map<String, dynamic> toFirebase() {
    return {
      'role': {
        'key': this._role.toString(),
        'priority': this.priority,
      },
    };
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  ROLE get role {
    return this._role;
  }

  String get name {
    switch (this._role) {
      case ROLE.MEMBER:
        return "Member";
        break;
      case ROLE.ADMIN:
        return "Admin";
        break;
      case ROLE.MASTER:
        return "Master";
        break;
      default:
        return "ERROR";
        break;
    }
  }

  IconData get icon {
    switch (this._role) {
      case ROLE.MEMBER:
        return Icons.group;
        break;
      case ROLE.ADMIN:
        return Icons.adb;
        break;
      case ROLE.MASTER:
        return Icons.speaker;
        break;
      default:
        return Icons.error;
        break;
    }
  }

  int get priority {
    switch (this._role) {
      case ROLE.MEMBER:
        return 0;
        break;
      case ROLE.ADMIN:
        return 2;
        break;
      case ROLE.MASTER:
        return 1;
        break;
      default:
        return -1;
        break;
    }
  }
}
