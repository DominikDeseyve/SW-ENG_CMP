import 'package:flutter/material.dart';

enum ROLE {
  MEMBER,
  ADMIN,
}

class Role {
  ROLE _role;
  bool _isMaster;

  Role(ROLE pRole, bool isMaster) {
    this._role = pRole;
    this._isMaster = isMaster;
  }
  Role.fromFirebase(Map pMap) {
    this._isMaster = pMap['is_master'];
    switch (pMap['key']) {
      case 'ROLE.MEMBER':
        this._role = ROLE.MEMBER;
        break;
      case 'ROLE.ADMIN':
        this._role = ROLE.ADMIN;
        break;
    }
  }

  Map<String, dynamic> toFirebase() {
    return {
      'role': {
        'key': this._role.toString(),
        'priority': this.priority,
        'is_master': this._isMaster,
      },
    };
  }

  set isMaster(bool pIsMaster) {
    this._isMaster = pIsMaster;
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  ROLE get role {
    return this._role;
  }

  bool get isMaster {
    return this._isMaster;
  }

  String get name {
    switch (this._role) {
      case ROLE.MEMBER:
        return "Member";
        break;
      case ROLE.ADMIN:
        return "Admin";
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
      default:
        return Icons.error;
        break;
    }
  }

  int get priority {
    switch (this._role) {
      case ROLE.MEMBER:
        return (this._isMaster ? 2 : 0);
        break;
      case ROLE.ADMIN:
        return (this._isMaster ? 2 : 1);
        break;
      default:
        return -1;
        break;
    }
  }
}
