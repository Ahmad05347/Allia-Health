import 'dart:async';

import 'package:allia_health/slider/slider_mam.dart';
import 'package:allia_health/widget/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmotionLevelPage extends StatelessWidget {
  final VoidCallback onNextPage;
  final String selectedEmotionImage;
  final String selectedEmotionText;
  final Function()? onBack;

  const EmotionLevelPage({
    super.key,
    required this.onNextPage,
    required this.selectedEmotionImage,
    required this.selectedEmotionText,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf9f7f3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFf9f7f3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: onBack,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                textWidget("You’re feeling", true, false, false),
                Text(
                  selectedEmotionText,
                  style: GoogleFonts.sourceSerif4(
                    color: const Color(
                      0xFFac8e63,
                    ),
                    fontSize: 40,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 300,
              child: FutureBuilder<ImageInfo>(
                future: _loadImage(selectedEmotionImage),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return SliderMam(emotionImage: snapshot.data!);
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            forwardButton(onNextPage),
          ],
        ),
      ),
    );
  }

  Future<ImageInfo> _loadImage(String asset) async {
    final completer = Completer<ImageInfo>();
    final ImageStream stream =
        AssetImage(asset).resolve(const ImageConfiguration());
    final listener = ImageStreamListener((ImageInfo info, bool syncCall) {
      completer.complete(info);
    });
    stream.addListener(listener);
    final ImageInfo imageInfo = await completer.future;
    stream.removeListener(listener);
    return imageInfo;
  }
}
