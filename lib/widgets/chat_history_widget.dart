import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled3/hive/chat_history.dart';
import 'package:untitled3/widgets/utilites.dart';

class ChatHistoryWidget extends StatelessWidget {
  const ChatHistoryWidget({super.key, required this.chat});

  final ChatHistory chat;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.only(left: 20, right: 20),
          leading: CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.chat,
              color: Colors.white,
            ),
            radius: 30,
          ),
          title: Text(
            chat.prompt,
            maxLines: 1,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            chat.response,
            maxLines: 2,
            style: GoogleFonts.poppins(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () async {
            // final chatProvider = context.read<ChatProvider>();
            // await chatProvider.prepareChatRoom(chaID: chat.chatId ,isNewChat: false);
            // chatProvider.setCurrentIndex(newIndex: 1);
            // chatProvider.pageController.jumpToPage(1);
          },
          onLongPress: () {
            showMyAnimatedDialog(
              context: context,
              title: 'Delets Chat',
              content: 'Are you sure you want to delete this chat?',
              actionText: 'Delete',
              onActionPressed: (value) {
                if (value) {}
              },
            );
          },
        ),
      ),
    );
  }
}
