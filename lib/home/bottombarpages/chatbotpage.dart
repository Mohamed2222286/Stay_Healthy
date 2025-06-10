import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/providers/chat_provider.dart';
import 'package:untitled3/widgets/assistant_message_widget.dart';
import 'package:untitled3/widgets/bottom_chat_field.dart';
import 'package:untitled3/widgets/my_message_widget.dart';
import 'package:untitled3/widgets/utilites.dart';
import '../../models/message.dart';

class Chatbotpage extends StatefulWidget {
  const Chatbotpage({super.key});

  @override
  State<Chatbotpage> createState() => _ChatbotpageState();
}

class _ChatbotpageState extends State<Chatbotpage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (_scrollController.hasClients &&
            _scrollController.position.maxScrollExtent > 0.5) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 50),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Consumer<ChatProvider>(
        builder: (context, ChatProvider, child) {
          if (ChatProvider.inChatMessage.isNotEmpty) {
            _scrollToBottom();
          }
          ChatProvider.addListener(
            () {
              if (ChatProvider.inChatMessage.isNotEmpty) {
                _scrollToBottom();
              }
            },
          );
          return Scaffold(
            appBar: AppBar(
              actions: [
                if (ChatProvider.inChatMessage.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(right: 25),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blue,
                      child: IconButton(
                        onPressed: () async {
                          showMyAnimatedDialog(
                            context: context,
                            title: 'Start New Chat',
                            content: 'Are you sure you want start a new chat?',
                            actionText: 'Yes',
                            onActionPressed: (value) async{
                              if(value){
                                await ChatProvider.prepareChatRoom(isNewChat: true, chaID: '');
                              }
                            },
                          );
                        },
                        icon: Icon(
                          Icons.add, color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
              leading: Padding(
                padding: EdgeInsets.only(left: 12),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage(
                          'assets/images/Diseño sin título - 2023-10-14T184728 1.png'),
                    )
                  ],
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ALEX',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '• ',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'Online',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xff9DC5EA), Color(0xffD0E2FF)])),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Expanded(
                        child: ChatMessages(
                            scrollController: _scrollController,
                            chatProvider: ChatProvider),
                      ),
                      BottomChatField(
                        chatProvider: ChatProvider,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

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
        return message.role.name == Role.user.name
            ? MyMessageWidget(message: message)
            : AssistantMessageWidget(message: message.message.toString());
      },
    );
  }
}
