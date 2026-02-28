import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:my_ai_chat/model/chat_model.dart';
import 'package:my_ai_chat/provider/chat_provider.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final chatProvider = context.watch<ChatProvider>();
    final chatTextEC = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("My AI Chat", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        actions: [CircleAvatar(child: Icon(Icons.person))],
        actionsPadding: EdgeInsets.only(right: 10),
      ),
      resizeToAvoidBottomInset: true,

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Consumer<ChatProvider>(
              builder: (context, provider, child) {
                if (provider.chats.isEmpty) {
                  return const Center(child: Text("Ask me anything!"));
                }

                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.separated(
                  itemCount: chatProvider.chats.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    bool isUser = chatProvider.chats[index].isUser;
                    ChatModel chat = chatProvider.chats[index];

                    if (isUser) {
                      //User prompt - right aligned
                      return Align(
                        alignment: AlignmentGeometry.topRight,
                        child: Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.deepPurple.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            chat.text,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 48, 27, 83),
                            ),
                          ),
                        ),
                      );
                    } else {
                      //Gemini response - left aligned
                      return Align(
                        alignment: AlignmentGeometry.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(right: 30),
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),

                          //Using markdown_widget package for rendering markdown text
                          child: MarkdownBlock(data: chat.text),
                        ),
                      );
                    }
                  },

                  separatorBuilder: (context, index) => SizedBox(height: 16),
                );
              },
            ),
          ),
          Align(
            alignment: AlignmentGeometry.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 252, 225, 255),

                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        controller: chatTextEC,
                        decoration: InputDecoration(hint: Text("Enter prompt")),
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color.fromARGB(255, 252, 225, 255),
                    child: IconButton(
                      onPressed: () => chatProvider.sendChat(chatTextEC.text),
                      icon: Icon(Icons.send),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
