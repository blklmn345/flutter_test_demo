import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_test_demo/utils/datetime_util.dart';
import 'package:flutter_test_demo/utils/degree_util.dart';

void main() {
  _UnitTests.start();
}

class _UnitTests {
  static void start() {
    group('DegreeUtils', () {
      test('degree/radian convert test', () {
        const double degree = 180.0;

        final double radian = DegreeUtil.deg2rad(degree);

        final double degree2 = DegreeUtil.rad2deg(radian);

        expect(radian, pi);

        expect(degree2, degree);
      });
    });

    group('DateTimeUtils', () {
      test('date between', () {
        final now = DateTime.now();

        DateTime start = now.subtract(const Duration(days: 1));
        DateTime end = now.add(const Duration(days: 1));

        final isBetween = now.isBetween(start, end);

        expect(isBetween, true);

        start = now;
        end = now;

        expect(now.isBetween(start, end), false);
      });
    });
  }
}
