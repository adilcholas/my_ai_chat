import 'package:flutter/material.dart';
import 'package:my_ai_chat/provider/chat_provider.dart';
import 'package:my_ai_chat/view/chat_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //Dependency Injection
        ChangeNotifierProvider<ChatProvider>(create: (_) => ChatProvider()),
      ],
      child: MaterialApp(debugShowCheckedModeBanner: false, home: 
      
      ChatScreen()),
    );
  }
}
