// Copyright 2019 Sumit Gulati. All rights reserved.

import 'package:flutter/material.dart';

abstract class CircularClock extends StatelessWidget {
  /// Create a const clock [CircularClock].
  ///
  /// All of the parameters are required and must not be null.
  const CircularClock({
    @required this.center,
    @required this.radius,
    @required this.filledIconCount,
  })  : assert(center != null),
        assert(radius != null),
        assert(filledIconCount != null);

  /// center of circle.
  final Offset center;

  /// Radius of circle
  final double radius;

  /// The filledIconCount
  final int filledIconCount;
}
