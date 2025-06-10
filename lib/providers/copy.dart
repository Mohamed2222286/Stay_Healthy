
import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:untitled3/apis/gemini_api_Services.dart';
import 'package:untitled3/constants.dart';
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

  String _modelType = 'gemini-pro';

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
              model: setCurrentModel(newmodel: 'gemini-pro'),
              apiKey: apiService.apiKey);
    } else {
      _model = _visionModel ??
          GenerativeModel(
              model: 'gemini-pro-vision', apiKey: apiService.apiKey);
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

  Future<void> sentMessage({
    required String message,
    required bool isTextOnly,
  }) async {
    await setModel(isTextOnly: isTextOnly);

    setLoading(value: true);

    String chatId = getChatId();

    List<Content> history = [];

    history = await getHistory(chatId: chatId);

    List<String> imagesUrls = getImagesUrls(isTextOnly: isTextOnly);

    final userMessage = Message(
      messageId:'',
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
    );
  }

  Future<void> sendMessageAndWaitForResponse(
      {required String message,
        required String chatId,
        required bool isTextOnly,
        required List<Content> history,
        required Message userMessage}) async {
    final chatSession = _model!.startChat(
      history: history.isEmpty || !isTextOnly ? null : history,
    );
    final content = await getContent(
      message: message,
      isTextOnly: isTextOnly,
    );

    final assistantMessage = userMessage.copyWith(
      messageId:'',
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
              element.role == Role.assistant,
        )
            .message
            .write(event.text);
        notifyListeners();
      },onDone: () {
      setLoading(value: false);
    },
    ).onError((erro, stackTrace){
      setLoading(value: false);
    });
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
          .map((bytes) => DataPart('image/jpg', Uint8List.fromList(bytes)))
          .toList();

      return Content.model([prompt, ...imageParts]);
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
