import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class EmojiThumbShape extends SfThumbShape {
  final ImageInfo emotionImage;

  EmojiThumbShape({required this.emotionImage});

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required RenderBox? child,
    required SfSliderThemeData themeData,
    SfRangeValues? currentValues,
    dynamic currentValue,
    required Paint? paint,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required SfThumb? thumb,
  }) {
    const double thumbSize = 60;
    final Rect thumbRect = Rect.fromCenter(
      center: center,
      width: thumbSize,
      height: thumbSize,
    );
    final Rect imageRect = Rect.fromCenter(
      center: center,
      width: thumbSize - 8,
      height: thumbSize - 8,
    );

    context.canvas.drawImageRect(
      emotionImage.image,
      Rect.fromLTWH(0, 0, emotionImage.image.width.toDouble(),
          emotionImage.image.height.toDouble()),
      imageRect,
      Paint(),
    );
  }
}
