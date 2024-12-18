import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trade_loop/core/utils/custom_text_widget.dart';
import 'package:trade_loop/core/utils/custom_button.dart';
import 'package:trade_loop/core/utils/snackbar_utils.dart';
import 'package:trade_loop/presentation/bloc/report_bloc/report_bloc.dart';
import 'package:trade_loop/presentation/products/widgets/custom_textformfield.dart';
import 'package:trade_loop/presentation/report/model/report_model.dart';

class ReportDetailPage extends StatefulWidget {
  final String sellerId;
  final String currentUserId;
  final String issueType;

  const ReportDetailPage({
    super.key,
    required this.sellerId,
    required this.currentUserId,
    required this.issueType,
  });

  @override
  State<ReportDetailPage> createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  final TextEditingController _explanationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display selected report type
            CustomTextWidget(
              text: 'Report Type: ${widget.issueType}',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            const CustomTextWidget(
              text: 'Explain the issue in more detail:',
              fontSize: 16,
            ),
            const SizedBox(height: 10),
            // Explanation TextField
            CustomTextFormField(
              controller: _explanationController,
              label: 'Explain your issue',
              maxLines: 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'This field cannot be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            CustomButton(
              label: 'Submit Report',
              onTap: () {
                if (_explanationController.text.isNotEmpty) {
                  final report = ReportModel(
                    sellerId: widget.sellerId,
                    userId: widget.currentUserId,
                    issueType: widget.issueType,
                    explanation: _explanationController.text,
                    reportDate: DateTime.now(),
                  );

                  context.read<ReportBloc>().add(SubmitReportEvent(report));

                  SnackbarUtils.showSnackbar(
                      context, 'Report submitted successfully');
                  Navigator.pop(context);
                } else {
                  SnackbarUtils.showSnackbar(
                      context, 'Please provide an explanation');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
