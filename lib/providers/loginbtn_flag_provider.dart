import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginButtonFlag extends ChangeNotifier {
  bool _isButtonClicked = false;

  LoginButtonFlag();

  void click() {
    _isButtonClicked = true;
    notifyListeners();
  }

  void unClick() {
    _isButtonClicked = false;
  }

  bool get status {
    return _isButtonClicked;
  }
}

final loginButtonFlagProvider = ChangeNotifierProvider<LoginButtonFlag>((ref) {
  return LoginButtonFlag();
});
