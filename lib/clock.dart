import 'dart:math';

import 'package:flutter/material.dart';

class Clock extends CustomPainter {
  late DateTime _dateTime;
  late bool _isRoman;
  late Color _minutesTickColor;
  late Color _hoursTickColor;
  late Color _digitColor;
  late List<Color> _backgroundGradientColors;
  Clock(
      {required DateTime dateTime,
      
      bool isRoman = false,
      Color minutesTickColor = Colors.deepOrange,
      Color hoursTickColor = Colors.amber,
      Color digitColor = Colors.amber,
      List<Color> backgroundGradientColors = const [Colors.black, Colors.grey]})
      : _dateTime = dateTime,
        _isRoman = isRoman,
        _minutesTickColor = minutesTickColor,
        _hoursTickColor = hoursTickColor,
        _digitColor = digitColor,
        _backgroundGradientColors = backgroundGradientColors;
  var _romanList = [
    'XII',
    'I',
    'II',
    'III',
    'IV',
    'V',
    'VI',
    'VII',
    'VIII',
    'IX',
    'X',
    'XI',
  ];
  var _numberList = [
    '12',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final center = Offset(width / 2, height / 2);
    final radius = min(width, height) / 2;
    final needleHoursRadius = radius * 0.04;
    final needleMinutesRadius = radius * 0.08;
    const needleMinutesTopMargin = 50.0;
    final needleHoursTopMargin = needleMinutesTopMargin + 10.0;
    final needleHoursPaint = Paint()
      ..color = _hoursTickColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10.0;
    final needleMinutePaint = Paint()
      ..color = _minutesTickColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8.0;
    const needleHourseBaseWidth = 6.0;
    const needleMinutesBaseWidth = 6.0;

    final angle = 2.0 * pi / 60.0;
    const double minutesTickLength = 6;
    const double MinutesTickWidth = 3;

    const double hoursTickLength = 10.0;
    const double hoursTickWidth = 6.0;

    final backgroundPaint = Paint()
      ..shader = LinearGradient(colors: _backgroundGradientColors)
          .createShader(Rect.fromCircle(center: center, radius: radius));
    final minutesTickPaint = Paint()
      ..color = _minutesTickColor
      ..strokeWidth = MinutesTickWidth;
    final hoursTickPaint = Paint()
      ..color = _hoursTickColor
      ..strokeWidth = hoursTickWidth;
    final textPainter = TextPainter()..textDirection = TextDirection.ltr;

    //Drawing backgroud for Clock
    canvas.drawCircle(center, radius, backgroundPaint);
    //Drawing Minutes Needle Base

    // Drawing Hours Needle Base
    canvas.drawCircle(center, needleHoursRadius, needleHoursPaint);
    //Drawing Needle Top
    canvas.drawLine(
        Offset(center.dx, center.dy - needleMinutesBaseWidth / 2),
        Offset(center.dx + radius - needleHoursTopMargin, center.dy),
        needleHoursPaint);
    canvas.drawLine(
        Offset(center.dx, center.dy + needleMinutesBaseWidth / 2),
        Offset(center.dx + radius - needleHoursTopMargin, center.dy),
        needleHoursPaint);
    canvas.save();
    canvas.translate(radius, radius);
    double tickLength;
    Paint paint;
    for (var i = 0; i < 60; i++) {
      var isHour = i % 5 == 0;
      tickLength = isHour ? hoursTickLength : minutesTickLength;
      paint = isHour ? hoursTickPaint : minutesTickPaint;
      canvas.drawLine(
          Offset(0, -radius), Offset(0, -radius + tickLength), paint);
      if (_dateTime.second == i) {
        canvas.drawCircle(Offset.zero, needleMinutesRadius, needleMinutePaint);
        //Drawing Needle Top
        canvas.drawLine(const Offset(-needleMinutesBaseWidth / 2, 0),
            Offset(0, -radius + needleMinutesTopMargin), needleMinutePaint);

        canvas.drawLine(Offset(needleMinutesBaseWidth / 2, 0),
            Offset(0, 0 - radius + needleMinutesTopMargin), needleMinutePaint);
      }
      if (isHour) {
        canvas.save();
        canvas.translate(0.0, -radius + 50);
        textPainter.text = TextSpan(
            text: _isRoman ? _romanList[i ~/ 5] : _numberList[i ~/ 5],
            style: TextStyle(color: _digitColor, fontSize: 33));
        textPainter.layout();
        textPainter.paint(
            canvas, Offset(-textPainter.width + 12, -textPainter.height));
        // canvas.rotate(-angle * i);
        canvas.restore();
      }
      canvas.rotate(angle);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(Clock oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(Clock oldDelegate) => true;
}
