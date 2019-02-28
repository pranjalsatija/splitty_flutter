import 'package:flutter/material.dart';

class Keyboard {
  BuildContext _context;

  Keyboard._withContext(this._context);

  static Keyboard of(BuildContext context) {
    return Keyboard._withContext(context);
  }

  void dismiss() => focus(FocusNode());

  void focus(FocusNode other) {
    FocusScope.of(_context).requestFocus(other);
  }
}