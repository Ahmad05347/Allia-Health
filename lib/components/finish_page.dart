import 'package:allia_health/widget/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FinishPage extends StatelessWidget {
  final VoidCallback onGoToHome;

  const FinishPage({
    super.key,
    required this.onGoToHome,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf9f7f3),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 244,
              height: 244,
              child: Image.asset(
                "assets/Mask group.png",
              ),
            ),
            Text(
              "Self report completed",
              style: GoogleFonts.sourceSerif4(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            myButton(
              "Go To Home",
              onGoToHome,
            ),
          ],
        ),
      ),
    );
  }
}
