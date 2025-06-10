import 'package:hive/hive.dart';
import 'package:untitled3/constants.dart';
import 'package:untitled3/hive/chat_history.dart';
import 'package:untitled3/hive/user_model.dart';

class Boxes {
  // get chat history box
  static Box<ChatHistory> getChatHIstory() =>
      Hive.box<ChatHistory>(Constants.chatHistoryBox);

//   get user box
  static Box<UserModel> getUser() => Hive.box<UserModel>(Constants.userBox);
}
