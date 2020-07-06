import 'package:verdulera_app/models/user.dart';
import 'package:flutter/foundation.dart';

class UserData extends ChangeNotifier {
  User _user;

  User get user {
    return _user;
  }

  bool userExists() {
    return _user != null;
  }

  void setUser({User user}) {
    _user = user;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }

  void changeName({String newName}) {
    _user.changeDisplayName(newName: newName);
    notifyListeners();
  }
}
