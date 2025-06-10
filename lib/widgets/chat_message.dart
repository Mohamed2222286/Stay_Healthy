import 'package:flutter/material.dart';
import '../models/message.dart';
import '../providers/chat_provider.dart';
import 'assistant_message_widget.dart';
import 'my_message_widget.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages(
      {super.key, required this.scrollController, required this.chatProvider});

  final ScrollController scrollController;
  final ChatProvider chatProvider;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: chatProvider.inChatMessage.length,
      itemBuilder: (context, index) {
        final message = chatProvider.inChatMessage[index];
        return message.role == Role.user
            ? MyMessageWidget(message: message)
            : AssistantMessageWidget(message: message.message.toString());
      },
    );
  }
}
