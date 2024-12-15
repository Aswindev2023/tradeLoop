import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trade_loop/presentation/authentication/models/user_model.dart';
import 'package:trade_loop/presentation/chat/models/chat_model.dart';
import 'package:trade_loop/presentation/chat/models/message_model.dart';

class ChatServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Creates a new chat document with the initial message.
  Future<String> createChat(
      String userId1, String userId2, String initialMessage) async {
    try {
      final existingChat = await _firestore
          .collection('chats')
          .where('participants', arrayContains: userId1)
          .get();

      for (var doc in existingChat.docs) {
        final participants = List<String>.from(doc.data()['participants']);
        if (participants.contains(userId2)) {
          return doc.id; // Return existing chat ID
        }
      }
      // Reference to chats collection
      final chatRef = _firestore.collection('chats').doc();

      // Create chat metadata
      final chat = ChatModel(
        chatId: chatRef.id,
        participants: [userId1, userId2],
        lastMessage: initialMessage,
        lastMessageTime: DateTime.now(),
        chatCreated: DateTime.now(),
      );

      // Add the chat to Firestore
      await chatRef.set(chat.toJson());

      return chat.chatId;
    } catch (e) {
      throw Exception("Failed to create chat: $e");
    }
  }

  /// Sends a message in a specific chat.
  Future<void> sendMessage(String chatId, MessageModel message) async {
    try {
      // Reference to messages subcollection
      final messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc();

      // Add message to Firestore
      await messageRef.set(message.toJson());

      // Update last message in chat metadata
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': message.content,
        'lastMessageTime': message.timestamp.toIso8601String(),
      });
    } catch (e) {
      throw Exception("Failed to send message: $e");
    }
  }

  /// Retrieves all messages in a specific chat (real-time).
  Stream<List<MessageModel>> getMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageModel.fromJson(doc.id, doc.data()))
            .toList());
  }

  /// Retrieves all chats for a user (real-time).
  Future<List<Map<String, dynamic>>> fetchChatsWithUserDetails(
      String userId) async {
    try {
      final chatDocs = await _firestore
          .collection('chats')
          .where('participants', arrayContains: userId)
          .orderBy('lastMessageTime', descending: true)
          .get();

      final chats = chatDocs.docs
          .map((doc) => ChatModel.fromJson(doc.id, doc.data()))
          .toList();

      final userDetails = <String, UserModel>{};

      for (var chat in chats) {
        for (var participantId in chat.participants) {
          if (!userDetails.containsKey(participantId)) {
            final userDoc =
                await _firestore.collection('users').doc(participantId).get();
            if (userDoc.exists) {
              userDetails[participantId] = UserModel.fromJson(userDoc.data()!);
            }
          }
        }
      }

      return chats.map((chat) {
        final participants =
            chat.participants.map((id) => userDetails[id]).toList();
        return {'chat': chat, 'participants': participants};
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch chats with user details: $e");
    }
  }

  /// Deletes a message in a specific chat.
  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      // Reference to the specific message document
      final messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc(messageId);

      // Delete the message from Firestore
      await messageRef.delete();
    } catch (e) {
      throw Exception("Failed to delete message: $e");
    }
  }

  /// Deletes an entire chat and its associated messages.
  Future<void> deleteChat(String chatId) async {
    try {
      // Reference to the chat document
      final chatRef = _firestore.collection('chats').doc(chatId);
      print('chat id in delete chat function is:$chatId');

      // Get all messages in the chat
      final messagesSnapshot = await chatRef.collection('messages').get();

      // Batch delete all messages
      final batch = _firestore.batch();
      for (var doc in messagesSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // Commit the batch deletion
      await batch.commit();

      // Delete the chat document
      await chatRef.delete();
    } catch (e) {
      throw Exception("Failed to delete chat: $e");
    }
  }
}
