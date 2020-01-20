// Copyright 2020 Sumit Gulati. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'dart:math' as math;

import 'circular_clock.dart';

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerTick = radians(360 / 12);

final int countSecondTicks = 12;

final verticalPI = math.pi / 2.0;

class HoursCircularClock extends CircularClock {
  /// Create a const clock [HoursCircularClock]. Clock for minutes and seconds.
  ///
  /// All of the parameters are required and must not be null.
  const HoursCircularClock({
    @required Offset center,
    @required double radius,
    @required int filledIconCount,
  })  : assert(center != null),
        assert(radius != null),
        assert(filledIconCount != null),
        super(center: center, radius: radius, filledIconCount: filledIconCount);

  @override
  Widget build(BuildContext context) {
    return new Center(child: getIconsWidgets());
  }

  Widget getIconsWidgets() {
    int hour = filledIconCount;
    if (filledIconCount >= 12) {
      hour -= 12;
    }
    List<Widget> list = new List<Widget>();
    Image chassedImg =
        Image(image: AssetImage('assets/yellow_dot.png'), width: 4, height: 4);
    Image mazeImg =
        Image(image: AssetImage('assets/white_dot.png'), width: 4, height: 4);
    Image pacmanImg =
        Image(image: AssetImage('assets/pacman.png'), width: 16, height: 16);
    Image cherryImg =
        Image(image: AssetImage('assets/cherry.png'), width: 16, height: 16);

    Widget childWidget = mazeImg;
    int positionDifference = 0;

    for (var index = 0; index < countSecondTicks; index++) {
      double rotationAngle = index * radiansPerTick;
      double angle = rotationAngle - verticalPI;

      final position =
          center + Offset(math.cos(angle), math.sin(angle)) * radius;

      if (index == 0 || index == 3 || index == 6 || index == 9) {
        childWidget = cherryImg;
        positionDifference = 6;
      } else if (index < hour) {
        childWidget = chassedImg;
        positionDifference = 0;
      } else {
        childWidget = mazeImg;
        positionDifference = 0;
      }

      if (index == hour) {
        // rotate the pacman image along with circle
        childWidget = Transform.rotate(angle: rotationAngle, child: pacmanImg);
        positionDifference = 6;
      }

      list.add(new Positioned(
        child: childWidget,
        top: position.dy - positionDifference,
        left: position.dx - positionDifference - 5,
      ));
    }
    return new Stack(children: list);
  }
}
