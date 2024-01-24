// ignore_for_file: file_names

class ChatBotMessages {
  static final List<String> messages = [
    "Hi there, how can I help you today?",
  ];

  static String getBotResponse(String message) {
    switch (message.toLowerCase()) {
      case 'hi':
        return 'yes';
      case 'I changed my mind':
        return 'Okay, let me know if you change your mind or if you have any other questions.';

      case 'i\'m not sure':
        return 'That\'s okay, please let me know if you need any help or advice.';

      default:
        return 'I\'m sorry, I didn\'t understand. Can you please rephrase or try another question?';
    }
  }

  static List<String> buildQuickReplyButtons(String lastMessage) {
    List<String> buttons = [];
    if (lastMessage.toLowerCase() == 'hi there, how can i help you today?') {
      buttons = [
        'There are gas leakage',
        'I need help',
      ];
    } else if (lastMessage.toLowerCase() == 'yes') {
      buttons = [
        'I changed my mind',
        'Do you have any other suggestions?',
      ];
    } else if (lastMessage.toLowerCase() == 'i\'m not sure') {
      buttons = [
        'Can you provide more information?',
        'What would you suggest?',
      ];
    }

    return buttons;
  }
}
