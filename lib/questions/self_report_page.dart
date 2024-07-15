import 'dart:convert';

import 'package:allia_health/components/finish_page.dart';
import 'package:allia_health/questions/likert_scale_questions.dart';
import 'package:allia_health/questions/single_choice_questions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SelfReportPage extends StatefulWidget {
  final String accessToken;
  const SelfReportPage({super.key, required this.accessToken});

  @override
  State<SelfReportPage> createState() => _SelfReportPageState();
}

class _SelfReportPageState extends State<SelfReportPage> {
  List<dynamic> questions = [];
  Map<int, dynamic> selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    const url = 'https://api-dev.allia.health/api/client/self-report/question';
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Authorization': 'Bearer ${widget.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        questions = jsonDecode(response.body);
      });
    } else {
      print('Failed to load questions');
    }
  }

  void submitAnswers() async {
    const url = 'https://api-dev.allia.health/api/client/self-report/answer';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${widget.accessToken}',
      },
      body: jsonEncode({
        'answers': selectedAnswers.entries.map((entry) {
          return {
            'questionId': entry.key,
            'selectedOptionId': entry.value,
            'freeformValue': null,
          };
        }).toList(),
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FinishPage(onGoToHome: onGoToHome)),
      );
    } else {
      print('Failed to submit answers');
    }
  }

  void onGoToHome() {
    Navigator.popUntil(context, ModalRoute.withName('/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Self Report'),
      ),
      body: questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                if (question['questionType'] == 'single_choice') {
                  return SingleChoiceQuestion(
                    question: question,
                    onChanged: (selectedOptionId) {
                      setState(() {
                        selectedAnswers[question['id']] = selectedOptionId;
                      });
                    },
                  );
                } else if (question['questionType'] == 'likert_scale') {
                  return LikertScaleQuestion(
                    question: question,
                    onChanged: (selectedOptionId) {
                      setState(() {
                        selectedAnswers[question['id']] = selectedOptionId;
                      });
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: submitAnswers,
        child: const Icon(Icons.check),
      ),
    );
  }
}
