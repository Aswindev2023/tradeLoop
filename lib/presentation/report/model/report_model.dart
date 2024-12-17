class ReportModel {
  final String sellerId; // ID of the reported seller
  final String userId; // ID of the current user (who is reporting)
  final String issueType; // Type of the issue (e.g., fraud, harassment, etc.)
  final String explanation; // Detailed explanation from the user
  final DateTime reportDate; // Timestamp of when the report was created

  ReportModel({
    required this.sellerId,
    required this.userId,
    required this.issueType,
    required this.explanation,
    required this.reportDate,
  });

  // Convert the report to a map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'sellerId': sellerId,
      'userId': userId,
      'issueType': issueType,
      'explanation': explanation,
      'reportDate': reportDate,
    };
  }

  // Create a ReportModel from a map (for retrieving data from Firestore)
  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      sellerId: map['sellerId'],
      userId: map['userId'],
      issueType: map['issueType'],
      explanation: map['explanation'],
      reportDate: map['reportDate'].toDate(),
    );
  }
}
