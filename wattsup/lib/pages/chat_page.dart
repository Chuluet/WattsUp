import 'package:flutter/material.dart';
import '../widgets/chat_input.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hola, ¿cómo va la carga?', 'isUser': false},
    {'text': 'Todo perfecto, gracias!', 'isUser': true},
  ];

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      _messages.add({'text': text, 'isUser': true});
    });
  }

  void _sendImage(String path) {
    setState(() {
      _messages.add({'image': path, 'isUser': true});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wattsup'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['isUser'];

                return Align(
                  alignment:
                  isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.green[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: msg.containsKey('image')
                        ? Image.asset(
                      msg['image'],
                      width: 180,
                      fit: BoxFit.cover,
                    )
                        : Text(
                      msg['text'],
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                );
              },
            ),
          ),
          ChatInput(
            onSendText: _sendMessage,
            onSendImage: _sendImage,
          ),
        ],
      ),
    );
  }
}
