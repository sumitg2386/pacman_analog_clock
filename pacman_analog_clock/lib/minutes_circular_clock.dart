// Copyright 2020 Sumit Gulati. All rights reserved.

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show radians;
import 'dart:math' as math;

import 'circular_clock.dart';

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

final int countSecondTicks = 60;

final verticalPI = math.pi / 2.0;

class MinutesCircularClock extends CircularClock {
  /// Create a const clock [MinutesCircularClock]. Clock for minutes and seconds.
  ///
  /// All of the parameters are required and must not be null.
  const MinutesCircularClock({
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
    List<Widget> list = new List<Widget>();
    Image chassedImg =
        Image(image: AssetImage('assets/yellow_dot.png'), width: 4, height: 4);
    Image mazeImg =
        Image(image: AssetImage('assets/white_dot.png'), width: 4, height: 4);
    Image pacmanImg =
        Image(image: AssetImage('assets/pacman.png'), width: 16, height: 16);
    Widget childWidget = mazeImg;
    int positionDifference = 0;

    for (var index = 0; index < countSecondTicks; index++) {
      double rotationAngle = index * radiansPerTick;
      double angle = rotationAngle - verticalPI;
      final position =
          center + Offset(math.cos(angle), math.sin(angle)) * radius;

      if (index < filledIconCount && index != 0) {
        childWidget = chassedImg;
        positionDifference = 0;
      } else if (index == filledIconCount) {
        // rotate the pacman image along with circle
        childWidget = Transform.rotate(angle: rotationAngle, child: pacmanImg);
        positionDifference = 6;
      } else {
        childWidget = mazeImg;
        positionDifference = 0;
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
