import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmotionWidget extends StatelessWidget {
  final String image;
  final String text;
  const EmotionWidget({
    super.key,
    required this.image,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      height: 240,
      decoration: BoxDecoration(
        color: const Color(0xFFffffff),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            offset: const Offset(
              1.0,
              10.0,
            ),
            blurRadius: 10.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            height: 80,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            text,
            style: GoogleFonts.sourceSerif4(
              color: const Color(
                0xFFac8e63,
              ),
              fontSize: 35,
            ),
          ),
        ],
      ),
    );
  }
}
