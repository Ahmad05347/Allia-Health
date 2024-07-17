import 'package:allia_health/widget/common_widgets.dart';
import 'package:allia_health/widget/emotion_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class EmotionPage extends StatefulWidget {
  final Function(int, int, String, String) onNextPage;
  final List<dynamic> questions;

  const EmotionPage({
    super.key,
    required this.onNextPage,
    required this.questions,
  });

  @override
  State<EmotionPage> createState() => _EmotionPageState();
}

class _EmotionPageState extends State<EmotionPage> {
  int currentPage = 0;
  final PageController ctrl = PageController(
    viewportFraction: 0.7,
    initialPage: 0,
  );

  List<EmotionWidget> imageWidgets = [
    const EmotionWidget(image: "assets/😊.png", text: "Happy"),
    const EmotionWidget(image: "assets/😤.png", text: "Frustrated"),
    const EmotionWidget(image: "assets/😞.png", text: "Sad"),
    const EmotionWidget(image: "assets/😡.png", text: "Angry"),
    const EmotionWidget(image: "assets/😌.png", text: "Peaceful"),
    const EmotionWidget(image: "assets/😀.png", text: "Excited"),
  ];

  int? selectedEmotionId;

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() {
      setState(() {
        currentPage = ctrl.page!.round();
      });
    });
  }

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  void _onEmotionSelected(int emotionId) {
    setState(() {
      selectedEmotionId = emotionId;
    });
    widget.onNextPage(
      widget.questions[0]['id'],
      selectedEmotionId!,
      imageWidgets[currentPage].text,
      imageWidgets[currentPage].image,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf9f7f3),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                textWidget(
                  "${widget.questions[0]['question']}",
                  true,
                  false,
                  false,
                ),
                textWidget(
                  "Select the number that best represents",
                  false,
                  false,
                  false,
                ),
                textWidget("your ${imageWidgets[currentPage].text} level",
                    false, false, false)
              ],
            ),
            SizedBox(
              height: 300,
              child: PageView.builder(
                allowImplicitScrolling: true,
                dragStartBehavior: DragStartBehavior.start,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padEnds: true,
                controller: ctrl,
                itemCount: widget.questions[0]['options'].length,
                itemBuilder: (_, index) {
                  double scale = currentPage == index ? 1.0 : 0.9;
                  return Transform.scale(
                    scale: scale,
                    child: GestureDetector(
                      onTap: () {
                        _onEmotionSelected(
                            widget.questions[0]['options'][index]['id']);
                      },
                      child: imageWidgets[index],
                    ),
                  );
                },
              ),
            ),
            forwardButton(
              () {
                _onEmotionSelected(
                    widget.questions[0]['options'][currentPage]['id']);
              },
            ),
          ],
        ),
      ),
    );
  }
}
