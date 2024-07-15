import 'package:allia_health/widget/common_widgets.dart';
import 'package:allia_health/widget/emotion_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class EmotionPage extends StatefulWidget {
  final Function(String, String) nextPage;
  const EmotionPage({super.key, required this.nextPage});

  @override
  State<EmotionPage> createState() => _EmotionPageState();
}

List<EmotionWidget> emotionWidget = [
  const EmotionWidget(
    image: "assets/😀.png",
    text: "Excited",
  ),
  const EmotionWidget(
    image: "assets/😊.png",
    text: "Happy",
  ),
  const EmotionWidget(
    image: "assets/😌.png",
    text: "Peaceful",
  ),
  const EmotionWidget(
    image: "assets/😞.png",
    text: "Sad",
  ),
  const EmotionWidget(
    image: "assets/😡.png",
    text: "Angry",
  ),
  const EmotionWidget(
    image: "assets/😤.png",
    text: "Frustrated",
  ),
];

class _EmotionPageState extends State<EmotionPage> {
  int currentPage = 0;
  final PageController ctrl = PageController(
    viewportFraction: 0.7,
    initialPage: 0,
  );

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
                textWidget("How are you feeling?", true, false, false),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textWidget(
                      "Select the number that best represents",
                      false,
                      false,
                      false,
                    ),
                  ],
                ),
                textWidget("your Excitement level.", false, false, false),
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
                itemCount: emotionWidget.length,
                itemBuilder: (_, index) {
                  double scale = currentPage == index ? 1.0 : 0.9;
                  return Transform.scale(
                    scale: scale,
                    child: GestureDetector(
                      onTap: () {
                        widget.nextPage(
                          emotionWidget[index].text,
                          emotionWidget[index].image,
                        );
                      },
                      child: emotionWidget[index],
                    ),
                  );
                },
              ),
            ),
            forwardButton(
              () {
                widget.nextPage(
                  emotionWidget[currentPage].text,
                  emotionWidget[currentPage].image,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
