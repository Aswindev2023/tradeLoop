import 'package:cloud_firestore/cloud_firestore.dart';

class WarningMessageModel {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;

  WarningMessageModel({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
  });

  // Factory method to create the model from Firestore document data
  factory WarningMessageModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return WarningMessageModel(
      id: snapshot.id,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}
