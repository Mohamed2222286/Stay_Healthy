class Message {
  final String messageId;
  final String chatId;
  final Role role;
  final StringBuffer message;
  final List<String> imagesUrls;
  final DateTime timeSent;

  Message({
    required this.messageId,
    required this.chatId,
    required this.role,
    required this.message,
    required this.imagesUrls,
    required this.timeSent,
  });

  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'chatId': chatId,
      'role': role.name, // Convert enum to string
      'message': message.toString(),
      'imagesUrls': imagesUrls,
      'timeSent': timeSent.toIso8601String(), // Convert DateTime to ISO string
    };
  }

  // Optional: Add fromMap constructor
  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map['messageId'],
      chatId: map['chatId'],
      role: Role.values[map['role']],
      // role: Role.values.firstWhere((e) => e.name == map['role']),
      message: StringBuffer(map['message']),
      imagesUrls: List<String>.from(map['imagesUrls']),
      timeSent: DateTime.parse(map['timeSent']),
    );
  }
  Message copyWith({
    String? messageId,
    String? chatId,
    Role? role,
    StringBuffer? message,
    List<String>? imagesUrls,
    DateTime? timeSent,
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
      chatId: chatId ?? this.chatId,
      role: role ?? this.role,
      message: message ?? this.message,
      imagesUrls: imagesUrls ?? this.imagesUrls,
      timeSent: timeSent ?? this.timeSent,
    );
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) return true ;

    return other is Message && other.messageId == messageId;


  }
  @override
  int get hashCode {
    return messageId.hashCode;
  }
}


enum Role {
  user,
  assistant, // Fixed typo
}

// Add extension for enum serialization if needed
extension RoleExtension on Role {
  String get name => toString().split('.').last;
}