import 'package:flutter/foundation.dart';

class SplashGuard extends ChangeNotifier {
  static final SplashGuard instance = SplashGuard._();
  SplashGuard._();

  bool _ready = false;
  bool get ready => _ready;

  void reset() => _ready = false;

  void markReady() {
    if (_ready) return;
    _ready = true;
    notifyListeners();
  }
}
