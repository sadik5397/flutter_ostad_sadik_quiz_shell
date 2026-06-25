import 'package:flutter/cupertino.dart';

class ThemePadding {
  static double value = 12;
  static EdgeInsets all = EdgeInsets.all(value);
  static EdgeInsets left = EdgeInsets.only(left: value);
  static EdgeInsets right = EdgeInsets.only(right: value);
  static EdgeInsets top = EdgeInsets.only(top: value);
  static EdgeInsets bottom = EdgeInsets.only(bottom: value);
  static EdgeInsets horizontal = EdgeInsets.symmetric(horizontal: value);
  static EdgeInsets vertical = EdgeInsets.symmetric(vertical: value);
  static EdgeInsets none = EdgeInsets.zero;
}
