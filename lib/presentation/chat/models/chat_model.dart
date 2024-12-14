class ChatModel {
  final String chatId;
  final List<String> participants;
  final String? lastMessage;
  final DateTime lastMessageTime;
  final DateTime chatCreated;

  ChatModel({
    required this.chatId,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.chatCreated,
  });

  // Factory method to create a Chat object from Firestore data
  factory ChatModel.fromJson(String id, Map<String, dynamic> json) {
    return ChatModel(
      chatId: id,
      participants: List<String>.from(json['participants']),
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
      chatCreated: DateTime.parse(json['chatCreated']),
    );
  }

  // Method to convert a Chat object into  JSON
  Map<String, dynamic> toJson() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'chatCreated': chatCreated.toIso8601String(),
    };
  }
}
