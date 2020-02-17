enum ROLE {
  MEMBER,
  ADMIN,
  MASTER,
}

class Role {
  ROLE _role;

  Role.fromFirebase(String pValue) {
    switch (pValue) {
      case 'MEMBER':
        this._role = ROLE.MEMBER;
        break;
      case 'ADMIN':
        this._role = ROLE.ADMIN;
        break;
      case 'MASTER':
        this._role = ROLE.MASTER;
        break;
    }
  }

  //***************************************************//
  //*********   GETTER
  //***************************************************//
  ROLE get role {
    return this._role;
  }
}
