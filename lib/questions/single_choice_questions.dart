import 'package:flutter/material.dart';

class SingleChoiceQuestion extends StatelessWidget {
  final Map<String, dynamic> question;
  final Function(int) onChanged;

  const SingleChoiceQuestion(
      {super.key, required this.question, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question['text']),
        ...question['options'].map<Widget>((option) {
          return RadioListTile<int>(
            title: Text(option['text']),
            value: option['id'],
            groupValue: question['selectedOptionId'],
            onChanged: (value) {
              onChanged(value!);
            },
          );
        }).toList(),
      ],
    );
  }
}
