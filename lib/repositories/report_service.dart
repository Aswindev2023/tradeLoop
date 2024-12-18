import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trade_loop/presentation/report/model/report_model.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitReport(ReportModel report) async {
    try {
      await _firestore.collection('reports').add(report.toMap());
    } catch (e) {
      throw Exception('Error submitting report: $e');
    }
  }
}
