import 'dart:async';
import 'dart:convert';

import 'package:allia_health/slider/slider_mam.dart';
import 'package:allia_health/widget/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class EmotionLevelPage extends StatefulWidget {
  final Future<void> Function(int) onNextPage;
  final String selectedEmotionImage;
  final String selectedEmotionText;
  final int questionId;
  final int selectedOptionId;
  String accessToken;
  final String refreshToken;
  final VoidCallback? onBack;

  EmotionLevelPage({
    Key? key,
    required this.onNextPage,
    required this.selectedEmotionImage,
    required this.selectedEmotionText,
    required this.questionId,
    required this.selectedOptionId,
    required this.accessToken,
    required this.refreshToken,
    this.onBack,
  }) : super(key: key);

  @override
  _EmotionLevelPageState createState() => _EmotionLevelPageState();
}

class _EmotionLevelPageState extends State<EmotionLevelPage> {
  int selectedLevel = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf9f7f3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFf9f7f3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                textWidget("You’re feeling", true, false, false),
                Text(
                  widget.selectedEmotionText,
                  style: GoogleFonts.sourceSerif4(
                    color: const Color(0xFFac8e63),
                    fontSize: 40,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 300,
              child: FutureBuilder<ImageInfo>(
                future: _loadImage(widget.selectedEmotionImage),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return SliderMam(
                      emotionImage: snapshot.data!,
                      onLevelChanged: (int level) {
                        setState(() {
                          selectedLevel = level;
                        });
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            forwardButton(() async {
              await _submitAnswer();
              await widget.onNextPage(selectedLevel);
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _submitAnswer() async {
    const apiUrl = 'https://api-dev.allia.health/api/client/self-report/answer';

    final answers = [
      {
        'questionId': widget.questionId,
        'selectedOptionId': widget.selectedOptionId,
        'freeformValue': null,
        'selectedLevel': selectedLevel,
      },
    ];

    final requestBody = jsonEncode({'answers': answers});

    final headers = {
      'Content-Type': 'application/json; charset=utf-8',
      'Authorization': widget.accessToken,
    };

    print('Request URL: $apiUrl');
    print('Request Headers: $headers');
    print('Request Body: $requestBody');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: requestBody,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Successfully submitted answer');
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          widget.onNextPage(selectedLevel);
        } else {
          print('Unexpected response format: ${response.body}');
        }
      } else if (response.statusCode == 419) {
        final newAccessToken = await _refreshToken();
        if (newAccessToken != null) {
          await _submitAnswer();
        } else {
          print('Failed to refresh token');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to refresh token')),
          );
        }
      } else {
        print('Failed to submit answer: ${response.statusCode}');
        String message = 'Failed to submit answer';
        if (response.body.isNotEmpty) {
          final jsonResponse = jsonDecode(response.body);
          if (jsonResponse.containsKey('message')) {
            message = jsonResponse['message'].toString();
          }
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      print('Exception occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('An error occurred while submitting the answer')),
      );
    }
  }

  Future<String?> _refreshToken() async {
    const refreshUrl = 'https://api-dev.allia.health/api/client/refresh-token';
    final response = await http.post(
      Uri.parse(refreshUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: jsonEncode({
        'refreshToken': widget.refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final newAccessToken = responseBody['accessToken'];
      setState(() {
        widget.accessToken = newAccessToken;
      });
      return newAccessToken;
    } else {
      return null;
    }
  }

  Future<ImageInfo> _loadImage(String asset) async {
    final completer = Completer<ImageInfo>();
    final ImageStream stream =
        AssetImage(asset).resolve(const ImageConfiguration());
    final listener = ImageStreamListener((ImageInfo info, bool syncCall) {
      completer.complete(info);
    });
    stream.addListener(listener);
    final ImageInfo imageInfo = await completer.future;
    stream.removeListener(listener);
    return imageInfo;
  }
}
