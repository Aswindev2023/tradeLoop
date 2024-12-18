class ReportModel {
  final String sellerId;
  final String userId;
  final String issueType;
  final String explanation;
  final DateTime reportDate;

  ReportModel({
    required this.sellerId,
    required this.userId,
    required this.issueType,
    required this.explanation,
    required this.reportDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'sellerId': sellerId,
      'userId': userId,
      'issueType': issueType,
      'explanation': explanation,
      'reportDate': reportDate,
    };
  }

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
