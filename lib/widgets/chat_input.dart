import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  final Function(String) onSendAction;
  ChatInput({required this.onSendAction, super.key});

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: "Type your message...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              onSendAction(_textController.text);
              _textController.clear();
            },
          ),
        ],
      ),
    );
  }
}
