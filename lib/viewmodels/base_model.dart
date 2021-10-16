import 'package:flutter/material.dart';

abstract class BaseViewModel with ChangeNotifier {

  bool _busy = false;
  String _error = '';

  String get error => _error;

  set error(String value) {
    _error = value;
  }

  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  void setBusyWithOutNotify(bool value) {
    _busy = value;
  }

  bool disposed = false;

  @override
  void notifyListeners() {
    if (!disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}