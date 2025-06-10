import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:untitled3/apis/gemini_api_Services.dart';
import 'package:untitled3/constants.dart';
import 'package:untitled3/hive/Boxes.dart';
import 'package:untitled3/hive/chat_history.dart';
import 'package:untitled3/hive/user_model.dart';
import 'package:untitled3/models/message.dart';
import 'package:uuid/uuid.dart';

class ChatProvider extends ChangeNotifier {
  List<Message> _inChatMessages = [];

  final PageController _pageController = PageController();

  List<XFile>? _imagesFileList = [];

  int _currentIndex = 0;

  String _currentChatId = '';

  GenerativeModel? _model;

  GenerativeModel? _textModel;

  GenerativeModel? _visionModel;

  String _modelType = 'gemini-2.0-flash';

  bool _isLoading = false;

  // getters
  List<Message> get inChatMessage => _inChatMessages;

  PageController get pageController => _pageController;

  List<XFile>? get imageFileList => _imagesFileList;

  int get currentIndex => _currentIndex;

  String get currentChatId => _currentChatId;

  GenerativeModel? get model => _model;

  GenerativeModel? get textModel => _textModel;

  GenerativeModel? get visionModel => _visionModel;

  String get modelType => _modelType;

  bool get isLoading => _isLoading;

  Future<void> setInChatMessages({required String chatId}) async {
    final messagesFromDB = await loadMessageFromDB(chatId: chatId);

    for (var message in messagesFromDB) {
      if (_inChatMessages.contains(message)) {
        log('message Already exists');
        continue;
      }
      _inChatMessages.add(message);
    }
    notifyListeners();
  }

  Future<List<Message>> loadMessageFromDB({required String chatId}) async {
    await Hive.openBox('${Constants.chatMessagesBox}$chatId');
    final messageBox = Hive.box('${Constants.chatMessagesBox}$chatId');

    final newdata = messageBox.keys.map(
      (e) {
        final message = messageBox.get(e);
        final messagedata = Message.fromMap(Map<String, dynamic>.from(message));

        return messagedata;
      },
    ).toList();
    notifyListeners();
    return newdata;
  }

  void setImagesFileList({required List<XFile> listValue}) {
    _imagesFileList = listValue;
    notifyListeners();
  }

  String setCurrentModel({required String newmodel}) {
    _modelType = newmodel;
    notifyListeners();
    return newmodel;
  }

  Future<void> setModel({required bool isTextOnly}) async {
    if (isTextOnly) {
      _model = _textModel ??
          GenerativeModel(
              model: setCurrentModel(newmodel: 'gemini-2.0-flash'),
              apiKey: apiService.apiKey);
    } else {
      _model = _visionModel ??
          GenerativeModel(model: 'gemini-2.0-flash', apiKey: apiService.apiKey);
    }
    notifyListeners();
  }

  void setCurrentIndex({required int newIndex}) {
    _currentIndex = newIndex;
    notifyListeners();
  }

  void setCurrentChatId({required String newChatId}) {
    _currentChatId = newChatId;
    notifyListeners();
  }

  void setLoading({required bool value}) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> prepareChatRoom({
    required bool isNewChat,
    required String chaID,
  }) async {
    if (!isNewChat) {
      final chatHistory = await loadMessageFromDB(chatId: chaID);
      _inChatMessages.clear();

      for (var message in chatHistory) {
        _inChatMessages.add(message);
      }
      setCurrentChatId(newChatId: chaID);
    } else {
      _inChatMessages.clear();
      setCurrentChatId(newChatId: chaID);
    }
  }

  Future<void> sentMessage({
    required String message,
    required bool isTextOnly,
  }) async {
    await setModel(isTextOnly: isTextOnly);

    setLoading(value: true);

    String chatId = getChatId();

    List<Content> history = [];

    // history Problems

    // history = await getHistory(chatId: chatId);

    List<String> imagesUrls = getImagesUrls(isTextOnly: isTextOnly);

    final messagesBox =
        await Hive.openBox('${Constants.chatMessagesBox}$chatId');

    log('messge Length : ${messagesBox.keys.length}');

    final userMessageId = messagesBox.keys.length;

    final assistantMessageId = messagesBox.keys.length + 1;

    log('userMessageId : ${userMessageId}');
    log('Model : ${userMessageId}');

    final userMessage = Message(
      messageId: userMessageId.toString(),
      chatId: chatId,
      role: Role.user,
      message: StringBuffer(message),
      imagesUrls: imagesUrls,
      timeSent: DateTime.now(),
    );

    _inChatMessages.add(userMessage);
    notifyListeners();

    if (currentChatId.isEmpty) {
      setCurrentChatId(newChatId: chatId);
    }

    await sendMessageAndWaitForResponse(
      message: message,
      chatId: chatId,
      isTextOnly: isTextOnly,
      history: history,
      userMessage: userMessage,
      modelMessageId: assistantMessageId.toString(),
      messagesBox: messagesBox,
    );
  }

  Future<void> sendMessageAndWaitForResponse({
    required String message,
    required String chatId,
    required bool isTextOnly,
    required List<Content> history,
    required Message userMessage,
    required String modelMessageId,
    required Box messagesBox,
  }) async {
    final chatSession = _model!.startChat(
      history: history.isEmpty || !isTextOnly ? null : history,
    );
    final content = await getContent(
      message: message,
      isTextOnly: isTextOnly,
    );

    final modelMessageId = const Uuid().v4();

    final assistantMessage = userMessage.copyWith(
      messageId: modelMessageId,
      role: Role.assistant,
      message: StringBuffer(),
      timeSent: DateTime.now(),
    );
    _inChatMessages.add(assistantMessage);
    notifyListeners();

    chatSession.sendMessageStream(content).asyncMap(
      (event) {
        return event;
      },
    ).listen(
      (event) {
        _inChatMessages
            .firstWhere(
              (element) =>
                  element.messageId == assistantMessage.messageId &&
                  element.role.name == Role.assistant.name,
            )
            .message
            .write(event.text);
        log('event: ${event.text}');
        notifyListeners();
      },
      onDone: () async {
        await saveMessageToDB(
          chatId: chatId,
          userMessage: userMessage,
          assistantMessage: assistantMessage,
          messagesBox: messagesBox,
        );
        log('stream done');
        setLoading(value: false);
      },
    ).onError((erro, stackTrace) {
      log('Error: $erro');
      setLoading(value: false);
    });
  }

  Future<void> saveMessageToDB({
    required String chatId,
    required Message userMessage,
    required Message assistantMessage,
    required Box messagesBox,
  }) async {

    await messagesBox.add(userMessage.toMap());
    await messagesBox.add(assistantMessage.toMap());

    final chatHistoryBox = Boxes.getChatHIstory();
    final chatHistory = ChatHistory(
      chatId: chatId,
      prompt: userMessage.message.toString(),
      response: assistantMessage.message.toString(),
      imagesUris: userMessage.imagesUrls,
      timestamp: DateTime.now(),
    );
    await chatHistoryBox.put(chatId, chatHistory);
    await messagesBox.close();
  }

  Future<Content> getContent({
    required String message,
    required bool isTextOnly,
  }) async {
    if (isTextOnly) {
      return Content.text(message);
    } else {
      final imageFutures = _imagesFileList
          ?.map(
            (imageFile) => imageFile.readAsBytes(),
          )
          .toList(
            growable: false,
          );
      final imageBytes = await Future.wait(imageFutures!);
      final prompt = TextPart(message);
      final imageParts = imageBytes
          .map((bytes) => DataPart('image/jpeg', Uint8List.fromList(bytes)))
          .toList();

      return Content.multi([prompt, ...imageParts]);
    }
  }

  List<String> getImagesUrls({
    required bool isTextOnly,
  }) {
    List<String> imagesUrls = [];
    if (!isTextOnly && imageFileList != null) {
      for (var image in imageFileList!) {
        imagesUrls.add(image.path);
      }
    }
    return imagesUrls;
  }

  Future<List<Content>> getHistory({required String chatId}) async {
    List<Content> history = [];
    if (currentChatId.isNotEmpty) {
      await setInChatMessages(chatId: chatId);

      for (var message in inChatMessage) {
        if (message.role == Role.user) {
          history.add(Content.text(message.message.toString()));
        } else {
          history.add(Content.model([TextPart(message.message.toString())]));
        }
      }
    }
    return history;
  }

  String getChatId() {
    if (currentChatId.isEmpty) {
      return const Uuid().v4();
    } else {
      return currentChatId;
    }
  }

  static initHive() async {
    final dir = await path.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await Hive.initFlutter(Constants.geminiDB);

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(chaHistoryAdapter());

      await Hive.openBox<ChatHistory>(Constants.chatHistoryBox);
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(userModelAdapter());
      await Hive.openBox<UserModel>(Constants.userBox);
    }
  }
}
