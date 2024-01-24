// ignore_for_file: file_names

import 'package:flutter/material.dart';

import 'chatBotMessage.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textEditingController = TextEditingController();

  late AnimationController _controller;
  List<String> _quickReplyButtons = [];

  void _handleMessage(String message) {
    String botResponse = ChatBotMessages.getBotResponse(message);
    setState(() {
      ChatBotMessages.messages.add('You: $message'); // Add user input
      if (botResponse.isNotEmpty) {
        ChatBotMessages.messages.add('Bot: $botResponse'); // Add bot response
        _quickReplyButtons =
            ChatBotMessages.buildQuickReplyButtons(botResponse);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _quickReplyButtons = ChatBotMessages.buildQuickReplyButtons(
        'Hi there, how can I help you today?');
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 37, 37),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemBuilder: (BuildContext context, int index) {
                if (index % 2 == 0) {
                  // User message
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(right: 10),
                            child: Text(
                              ChatBotMessages.messages[index],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // Bot message
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.all(10),
                            margin: const EdgeInsets.only(left: 10),
                            child: Text(
                              ChatBotMessages.messages[index],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
              itemCount: ChatBotMessages.messages.length,
            ),
          ),
          if (_quickReplyButtons.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  for (String buttonLabel in _quickReplyButtons)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            String quickReplyMessage = buttonLabel;
                            setState(() {
                              _textEditingController.text = quickReplyMessage;
                              _quickReplyButtons =
                                  ChatBotMessages.buildQuickReplyButtons(
                                      quickReplyMessage);
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                          icon: const Icon(
                            Icons.send,
                            size: 18,
                          ),
                          label: Text(buttonLabel),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          Container(
            color: const Color.fromARGB(255, 36, 37, 37),
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Type your message here',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                FloatingActionButton(
                  onPressed: () {
                    String message = _textEditingController.text;
                    if (message.isNotEmpty) {
                      setState(() {
                        _quickReplyButtons.clear();
                        _textEditingController.clear();
                        _handleMessage(message);
                      });
                      _controller.reset();
                      _controller.forward();
                    }
                  },
                  child: const Icon(Icons.send),
                ),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      ChatBotMessages.messages.clear();
                      _quickReplyButtons =
                          ChatBotMessages.buildQuickReplyButtons(
                              'Hi there, how can I help you today?');
                    });
                  },
                  child: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
