import 'package:allia_health/widget/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage extends StatelessWidget {
  final VoidCallback onNextPage;
  const IntroPage({super.key, required this.onNextPage});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: [
              textWidget(
                "Hi David, How are you?",
                true,
                false,
                false,
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.only(
            top: 30,
            right: 10,
            bottom: 20,
          ),
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            color: const Color(
              0xFFac8e63,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textWidget(
                "Help your Therapist know\nhow to best support you",
                true,
                true,
                true,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  TextButton(
                    onPressed: onNextPage,
                    child: Text(
                      "Take a Check-in",
                      style: GoogleFonts.sourceSans3(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
