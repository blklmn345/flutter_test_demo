import 'dart:math';

class DegreeUtil {
  /// degree to radian
  static double deg2rad(double deg) {
    return deg * (pi / 180);
  }

  /// radian to degree
  static double rad2deg(double rad) {
    return rad * (180 / pi);
  }
}
