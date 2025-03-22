import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/message.dart';

class ChatProvider extends ChangeNotifier {
  List<Message> messages = [];

  Future<void> sendMessage(String userInput) async {
    messages.add(Message(text: userInput, isUser: true));
    notifyListeners();

    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/analyze_emotions"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"text": userInput}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String aiResponse = data["ai_response"];

      messages.add(Message(text: aiResponse, isUser: false));
      notifyListeners();
    } else {
      messages.add(
        Message(text: "Error: Unable to fetch response", isUser: false),
      );
      notifyListeners();
    }
  }
}
