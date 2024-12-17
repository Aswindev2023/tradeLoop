import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trade_loop/presentation/report/model/report_model.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a report for a seller
  Future<void> submitReport(ReportModel report) async {
    try {
      await _firestore
          .collection('reports')
          .doc(report.sellerId)
          .collection('userReports')
          .add(report.toMap());
    } catch (e) {
      throw Exception('Error submitting report: $e');
    }
  }
}
