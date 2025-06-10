import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled3/models/message.dart';
import 'package:provider/provider.dart';
import 'package:untitled3/providers/chat_provider.dart';

class PreviewImagesWidget extends StatelessWidget {
  const PreviewImagesWidget({super.key, this.message});

  final Message? message;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, ChatProvider, child) {
        final messageToShow =
            message != null ? message!.imagesUrls : ChatProvider.imageFileList;
        final padding = message != null
            ? EdgeInsets.zero
            : EdgeInsets.only(left: 8.0, right: 8.0);
        return Padding(
          padding: padding,
          child: SizedBox(
            height: 100,
            width: 150,
            child: ListView.builder(
              itemCount: messageToShow!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.fromLTRB(4.0, 8.0, 4.0, 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.file(
                        File(message != null
                            ? message!.imagesUrls[index]
                            : ChatProvider.imageFileList![index].path),
                        height: 80,
                        width: 150 ,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
