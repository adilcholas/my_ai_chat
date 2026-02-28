import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:my_ai_chat/model/chat_model.dart';

class ChatProvider with ChangeNotifier {
  final List<ChatModel> _chats = [];
  bool _isLoading = false;

  List<ChatModel> get chats => _chats;
  bool get isLoading => _isLoading;

  //Send chat method passes text field value from chat screen
  Future<void> sendChat(String text) async {
    const apiKey = String.fromEnvironment("GEMINI_API_KEY");

    late final GenerativeModel model = GenerativeModel(
      model: 'gemini-3-flash-preview',
      apiKey: apiKey,
    );

    if (text.trim().isEmpty) return;

    _chats.add(ChatModel(text: text, isUser: true));
    _isLoading = true;
    notifyListeners();

    try {
      final response = await model.generateContent([Content.text(text)]);

      if (response.text != null) {
        _chats.add(ChatModel(text: response.text!, isUser: false));

        debugPrint(response.text);
      }
    } catch (e) {
      throw Exception("Error occured : $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
