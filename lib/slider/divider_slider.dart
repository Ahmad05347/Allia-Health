import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class DividerSlider extends SfDividerShape {
  @override
  void paint(
    PaintingContext context,
    Offset center,
    Offset? thumbCenter,
    Offset? startThumbCenter,
    Offset? endThumbCenter, {
    required RenderBox parentBox,
    required SfSliderThemeData themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    required Paint? paint,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
  }) {
    bool isActive;

    switch (textDirection) {
      case TextDirection.ltr:
      case TextDirection.rtl:
        isActive = center.dy >= thumbCenter!.dy;
        break;
    }

    context.canvas.drawRect(
      Rect.fromCenter(center: center, width: 60.0, height: 5.0),
      Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.fill
        ..color =
            isActive ? themeData.activeTrackColor! : const Color(0xFFf1ede3),
    );
  }
}
