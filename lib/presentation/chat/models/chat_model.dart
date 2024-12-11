class ChatModel {
  final String chatId; // Unique ID for the chat
  final List<String> participants; // List of user IDs in the chat
  final String? lastMessage; // The content of the last message
  final DateTime lastMessageTime; // Timestamp of the last message
  final DateTime chatCreated; // Timestamp when the chat was created

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

  // Method to convert a Chat object into Firestore-compatible JSON
  Map<String, dynamic> toJson() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'chatCreated': chatCreated.toIso8601String(),
    };
  }
}
