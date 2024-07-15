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
  String accessToken = '';
  String clientId = '';

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
        return EmotionPage(nextPage: onEmotionPageNext);
      case 2:
        return EmotionLevelPage(
          selectedEmotionImage: selectedEmotionImage,
          selectedEmotionText: selectedEmotionText,
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
      setState(() {
        accessToken = loginData['body']['accessToken'];
        clientId = loginData['body']['client']['id'].toString();
      });
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

  void onIntroPageNext() {
    print('Proceed to next page manually');
    setState(() {
      currentPage = 1;
    });
  }

  Future<void> onEmotionLevelPageNext() async {
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
              'questionId': 1,
              'selectedOptionId': 1,
              'freeformValue': null,
            },
          ],
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Successfully submitted answers');
        setState(() {
          currentPage = 3;
        });
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

  void onEmotionPageNext(String text, String image) {
    setState(() {
      selectedEmotionText = text;
      selectedEmotionImage = image;
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
