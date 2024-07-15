import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

textWidget(String text, bool isSize, bool isWeight, bool isColor) {
  return Text(
    text,
    style: GoogleFonts.sourceSerif4(
      fontSize: isSize ? 25 : 15,
      fontWeight: isWeight ? FontWeight.w300 : FontWeight.normal,
      color: isColor ? Colors.white : Colors.black,
    ),
  );
}

forwardButton(final Function() onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(top: 10, bottom: 30),
      width: 60,
      height: 60,
      decoration: const BoxDecoration(
        color: Color(
          0xFF2e959e,
        ),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.arrow_forward_outlined,
          color: Colors.white,
          size: 40,
        ),
      ),
    ),
  );
}

myButton(String text, final Function() onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 60,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(
          0xFF2e959e,
        ),
        borderRadius: BorderRadius.circular(
          8,
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.sourceSerif4(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    ),
  );
}
