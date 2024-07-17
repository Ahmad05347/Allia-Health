import 'dart:convert';

import 'package:allia_health/auth/auth_services.dart';
import 'package:allia_health/components/emotion_level_page.dart';
import 'package:allia_health/components/emotion_page.dart';
import 'package:allia_health/components/finish_page.dart';
import 'package:allia_health/components/intro_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  String selectedEmotionText = '';
  String selectedEmotionImage = '';
  int questionId = 0;
  int selectedOptionId = 0;
  int selectedLevel = 1;
  String accessToken =
      'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJFbWFpbCI6ImRldkBhbGxpYXVrLmNvbSIsInVzZXJUeXBlIjoiY2xpZW50IiwiZW52IjoiZGV2IiwiaGFzaCI6Ikl6MFdUL3FLMWUiLCJpYXQiOjE3MjEyMDA3MzYsImV4cCI6MTcyMTIwMjUzNn0.Fx7kG3Q0IsqhXA6_DPZvFHUinGD4KUi1wRFXKpXY6Xw';
  String refreshToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjEsInVzZXJFbWFpbCI6ImRldkBhbGxpYXVrLmNvbSIsInVzZXJUeXBlIjoiY2xpZW50IiwiaGFzaCI6Ikl6MFdUL3FLMWUiLCJlbnYiOiJkZXYiLCJpYXQiOjE3MjEyMDA3MzYsImV4cCI6MTcyMTQ1OTkzNn0.mFZUUT5js2ZaP31cObv4mcAkyAI13hFQgdwfXHA0sKo';
  String clientId = '';
  List<dynamic> questions = [];

  @override
  void initState() {
    super.initState();
    login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentStep(),
    );
  }

  Widget currentStep() {
    switch (currentPage) {
      case 0:
        return IntroPage(onNextPage: onIntroPageNext);
      case 1:
        return EmotionPage(onNextPage: onEmotionPageNext, questions: questions);
      case 2:
        return EmotionLevelPage(
          accessToken: accessToken,
          refreshToken: refreshToken,
          selectedEmotionImage: selectedEmotionImage,
          selectedEmotionText: selectedEmotionText,
          questionId: questionId,
          selectedOptionId: selectedOptionId,
          onNextPage: onEmotionLevelPageNext,
          onBack: () {
            setState(() {
              currentPage = 1;
            });
          },
        );
      case 3:
        return FinishPage(onGoToHome: onGoToHome);
      default:
        return Container();
    }
  }

  Future<void> login() async {
    try {
      final Map<String, dynamic> loginData =
          await AuthService.login('dev@alliauk.com', '12345678');
      print('Login Data: $loginData');
      setState(() {
        accessToken = loginData['body']['accessToken'] ?? '';
        refreshToken = loginData['body']['refreshToken'] ?? '';
        clientId = loginData['body']['client']['id']?.toString() ?? '';
      });

      if (accessToken.isEmpty || clientId.isEmpty) {
        throw Exception('Access token or client ID is missing.');
      }

      await fetchInitialData();
      print('Logged in successfully');
    } catch (e) {
      print('Failed to login: $e');
      String errorMessage = 'Failed to login. Please check your credentials.';
      if (e is Exception) {
        errorMessage = 'Failed to login: $e';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<void> fetchInitialData() async {
    var headers = {'Authorization': 'Bearer $accessToken'};
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://api-dev.allia.health/api/client/self-report/question'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final List<dynamic> responseData = jsonDecode(responseBody)['body'];
      print(responseBody);
      setState(() {
        questions = responseData;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  void onIntroPageNext() {
    setState(() {
      currentPage = 1;
    });
  }

  Future<void> onEmotionLevelPageNext(int level) async {
    setState(() {
      selectedLevel = level;
    });

    const apiUrl = 'https://api-dev.allia.health/api/client/self-report/answer';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'answers': [
            {
              'questionId': questionId,
              'selectedOptionId': selectedOptionId,
              'freeformValue': null,
              'selectedLevel': selectedLevel,
            },
          ],
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Successfully submitted answers');
        setState(() {
          currentPage = 3;
        });
      } else if (response.statusCode == 419) {
        await _refreshToken();
        await onEmotionLevelPageNext(selectedLevel);
      } else {
        print('Failed to submit answers: ${response.statusCode}');
        String message = 'Failed to submit answers';
        if (response.body != null) {
          final jsonResponse = jsonDecode(response.body);
          if (jsonResponse.containsKey('message')) {
            message = jsonResponse['message'];
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      print('Error submitting answers: $e');
      String errorMessage = 'Failed to submit answers. Please try again later.';
      if (e is Exception) {
        errorMessage = 'Failed to submit answers: $e';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<void> _refreshToken() async {
    const refreshUrl = 'https://api-dev.allia.health/api/client/auth/refresh';
    final response = await http.post(
      Uri.parse(refreshUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'refreshToken': refreshToken,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      setState(() {
        accessToken = jsonResponse['accessToken'];
      });
      print('Token refreshed successfully');
    } else {
      print('Failed to refresh token: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to refresh token')),
      );
    }
  }

  void onEmotionPageNext(
    int questionId,
    int selectedOptionId,
    String emotionText,
    String emotionImage,
  ) {
    setState(() {
      this.questionId = questionId;
      this.selectedOptionId = selectedOptionId;
      this.selectedEmotionText = emotionText;
      this.selectedEmotionImage = emotionImage;
      currentPage = 2;
    });
  }

  void onGoToHome() {
    setState(() {
      currentPage = 0;
      selectedEmotionText = '';
      selectedEmotionImage = '';
      accessToken = '';
      clientId = '';
    });
  }
}
