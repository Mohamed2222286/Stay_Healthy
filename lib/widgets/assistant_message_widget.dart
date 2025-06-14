import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AssistantMessageWidget extends StatelessWidget {
  const AssistantMessageWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/applogo.png',
          height: 50,
          width: 50,
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            decoration: BoxDecoration(
              color: Color(0xffEEEEEE),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(bottom: 8),
            child: message.isEmpty
                ? SizedBox(
                    width: 50,
                    child: SpinKitThreeBounce(
                      color: Colors.blueGrey,
                      size: 20.0,
                    ),
                  )
                : MarkdownBody(
                    data: message,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      p: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      strong: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
