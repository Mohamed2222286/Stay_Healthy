import 'package:flutter/material.dart';

class EmptyHistoryWidget extends StatelessWidget {
  const EmptyHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () async {
          // final chatProvider = context.read<ChatProvider>();
          // await chatProvider.prepareChatRoom(chaID: '', isNewChat: true);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('No Chat Found,Start a New Chat'),
          ),
        ),
      ),
    );
  }
}
