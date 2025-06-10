import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:untitled3/hive/Boxes.dart';
import 'package:untitled3/hive/chat_history.dart';
import 'package:untitled3/widgets/empty_history_widget.dart';
import '../../../../widgets/chat_history_widget.dart';

class Historyscreen extends StatefulWidget {
  const Historyscreen({super.key});

  @override
  State<Historyscreen> createState() => _HistoryscreenState();
}

class _HistoryscreenState extends State<Historyscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text('Chat History' , style: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),),
      ),
      body: ValueListenableBuilder<Box<ChatHistory>>(
        valueListenable: Boxes.getChatHIstory().listenable(),
        builder: (context, box, _) {
          final chatHistory = box.values.toList().cast<ChatHistory>();
          return chatHistory.isEmpty
              ? EmptyHistoryWidget()
              : ListView.builder(
                  itemCount: chatHistory.length,
                  itemBuilder: (context, index) {
                    final chat = chatHistory[index];
                    return ChatHistoryWidget(chat: chat,);
                  },
                );
        },
      ),
    );
  }
}
