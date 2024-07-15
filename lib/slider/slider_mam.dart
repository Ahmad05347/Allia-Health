import 'package:allia_health/slider/divider_slider.dart';
import 'package:allia_health/slider/emoji_thumb_shape.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SliderMam extends StatefulWidget {
  final ImageInfo emotionImage;
  const SliderMam({super.key, required this.emotionImage});

  @override
  State<SliderMam> createState() => _SliderMamState();
}

double _value = 0.0;

class _SliderMamState extends State<SliderMam> {
  @override
  Widget build(BuildContext context) {
    return SfSliderTheme(
      data: const SfSliderThemeData(
        thumbRadius: 5,
        thumbStrokeWidth: 20,
        inactiveDividerRadius: 30,
        activeTrackHeight: 20,
        activeTrackColor: Color(0xFF2e959e),
        inactiveTrackColor: Color(0xFFf1ede3),
        inactiveTickColor: Color(0xFFf1ede3),
        activeTickColor: Color(0xFF2e959e),
        activeDividerColor: Color(0xFF2e959e),
        inactiveDividerStrokeWidth: 30,
        inactiveTrackHeight: 20,
        activeDividerRadius: 10,
        overlayRadius: 10,
        trackCornerRadius: 30,
        activeDividerStrokeColor: Color(0xFF2e959e),
        activeMinorTickColor: Color(0xFFf1ede3),
        inactiveDividerColor: Color(0xFFf1ede3),
      ),
      child: SfSlider.vertical(
        activeColor: const Color(0xFF2e959e),
        thumbShape: EmojiThumbShape(emotionImage: widget.emotionImage),
        min: 0.0,
        max: 100.0,
        interval: 25,
        showDividers: true,
        dividerShape: DividerSlider(),
        value: _value,
        onChanged: (dynamic newValue) {
          setState(() {
            _value = newValue;
          });
        },
      ),
    );
  }
}
