import 'package:chat_gpt_demo/widgets/chat_input.dart';
import 'package:chat_gpt_demo/widgets/waiting_indicator.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';

import 'models/message.dart';
import 'widgets/receiver_message.dart';
import 'widgets/sender_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  late OpenAI _openAI;
  bool _isWaiting = false;

  @override
  void initState() {
    super.initState();

    const token = "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";

    _openAI = OpenAI.instance.build(
      token: token,
      baseOption: HttpSetup(receiveTimeout: 6000),
      isLogger: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("OpenAI Chat Bot"),
        ),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final message = _messages[index];
                    return message.isReceiver
                        ? ReceiverMessage(text: message.text)
                        : SenderMessage(text: message.text);
                  },
                ),
              ),
              if (_isWaiting)
                SizedBox(
                  height: 50.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      WaitingIndicator(),
                      SizedBox(width: 10.0),
                      Text('Waiting for response...'),
                    ],
                  ),
                ),
              ChatInput(onSendAction: (text) => _onSendAction(text)),
            ],
          ),
        ),
      ),
    );
  }

  _onSendAction(String message) async {
    debugPrint("onSend Action called");
    setState(() {
      _isWaiting = true;
      _messages.insert(0, Message(text: message, isReceiver: false));
    });

    final response = await _openAI.onCompleteText(
      request: CompleteText(
        prompt: message,
        model: kTranslateModelV3,
      ),
    );

    final responseString = response?.choices.first.text;
    if (responseString != null && responseString.isNotEmpty) {
      setState(() {
        _isWaiting = false;
        _messages.insert(
            0, Message(text: responseString.trim(), isReceiver: true));
      });
    }
  }
}
