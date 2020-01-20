// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Modified by Sumit Gulati

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:intl/intl.dart';

import 'hours_circular_clock.dart';
import 'minutes_circular_clock.dart';

/// A Kids pacman analog clock.
class AnalogClock extends StatefulWidget {
  const AnalogClock(this.model);

  final ClockModel model;

  @override
  _AnalogClockState createState() => _AnalogClockState();
}

class _AnalogClockState extends State<AnalogClock> {
  var _now = DateTime.now();
  var _temperature = '';
  var _temperatureRange = '';
  var _condition = '';
  var _location = '';
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(AnalogClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      _temperature = widget.model.temperatureString;
      _temperatureRange = '(${widget.model.low} - ${widget.model.highString})';
      _condition = widget.model.weatherString;
      _location = widget.model.location;
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            backgroundColor: Color(0xFFD2E3FC),
            primaryColor: Color(0xFF4285F4),
          )
        : Theme.of(context).copyWith(
            backgroundColor: Color(0xFF3C4043),
            primaryColor: Color(0xFFD2E3FC),
          );

    final time = DateFormat.Hms().format(DateTime.now());
    final weatherInfo = DefaultTextStyle(
      style: TextStyle(color: customTheme.primaryColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_temperature),
          Text(_temperatureRange),
          Text(_condition),
          Text(_location),
        ],
      ),
    );

    var screenSize = MediaQuery.of(context).size;
    double statusBarHeight = MediaQuery.of(context).padding.top;

    var screenCenter = screenSize.center(Offset.zero);
    var width = screenSize.width, height = screenSize.height - statusBarHeight;
    var centerX, centerY;
    if (width < height) {
      centerX = screenCenter.dx;
      centerY = 3 * centerX / 5;
    } else {
      centerY = height / 2;
      centerX = 5 * centerY / 3;
    }

    final center = Offset(centerX, centerY);
    Image ghostImg =
        Image(image: AssetImage('assets/ghost.png'), width: 36, height: 36);
    Image ghostChassedImg = Image(
        image: AssetImage('assets/ghost_chassed.png'), width: 36, height: 36);
    Image centerImg = _now.second == 0 ? ghostChassedImg : ghostImg;
    return Semantics.fromProperties(
      properties: SemanticsProperties(
        label: 'Analog clock with time $time',
        value: time,
      ),
      child: Container(
        color: customTheme.backgroundColor,
        child: Stack(
          children: [
            MinutesCircularClock(
              center: center,
              radius: 90,
              filledIconCount: _now.second,
            ),
            MinutesCircularClock(
              center: center,
              radius: 75,
              filledIconCount: _now.minute,
            ),
            HoursCircularClock(
              center: center,
              radius: 60,
              filledIconCount: _now.hour,
            ),
            Center(child: centerImg),
            Positioned(
              left: 0,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: weatherInfo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
