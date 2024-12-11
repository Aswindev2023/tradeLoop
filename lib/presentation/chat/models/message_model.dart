class MessageModel {
  final String messageId; // Unique ID for the message
  final String senderId; // ID of the user who sent the message
  final String content; // Text content of the message
  final DateTime timestamp; // Timestamp when the message was sent
  final String type; // "text" (for now), extendable later to "image", etc.

  MessageModel({
    required this.messageId,
    required this.senderId,
    required this.content,
    required this.timestamp,
    required this.type,
  });

  // Factory method to create a Message object from Firestore data
  factory MessageModel.fromJson(String id, Map<String, dynamic> json) {
    return MessageModel(
      messageId: id,
      senderId: json['senderId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      type: json['type'],
    );
  }

  // Method to convert a Message object into Firestore-compatible JSON
  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
    };
  }
}
