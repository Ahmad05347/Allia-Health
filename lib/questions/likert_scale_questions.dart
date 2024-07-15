import 'package:flutter/material.dart';

class LikertScaleQuestion extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(int) onChanged;

  const LikertScaleQuestion(
      {super.key, required this.question, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question['text']),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: question['options'].map<Widget>((option) {
            return GestureDetector(
              onTap: () {
                onChanged(option['id']);
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(option['text']),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
