import 'package:flutter/cupertino.dart';

class ThemeSpacing {
  static double value = 16;
  static Widget horizontal = SizedBox(width: value);
  static Widget horizontalHalf = SizedBox(width: value / 2);
  static Widget horizontalX2 = SizedBox(width: value * 2);
  static Widget horizontalX3 = SizedBox(width: value * 3);
  static Widget vertical = SizedBox(height: value);
  static Widget verticalHalf = SizedBox(height: value / 2);
  static Widget verticalX2 = SizedBox(height: value * 2);
  static Widget verticalX3 = SizedBox(height: value * 3);
  static Widget space = SizedBox(height: value, width: value);
}
