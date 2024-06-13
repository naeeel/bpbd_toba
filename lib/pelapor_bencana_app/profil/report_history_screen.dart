import 'package:flutter/material.dart';
import 'package:pelaporan_bencana/model/report_status.dart';

class ReportHistoryScreen extends StatelessWidget {
  final List<Report> userReports;

  ReportHistoryScreen({required this.userReports});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historis Pelaporan'),
      ),
      body: userReports.isEmpty
          ? Center(child: Text('Belum ada laporan yang dikirim.'))
          : ListView.builder(
        itemCount: userReports.length,
        itemBuilder: (context, index) {
          final report = userReports[index];
          return ListTile(
            leading: report.getStatusIcon(),
            title: Text(report.disasterType),
            subtitle: Text(report.getFormattedTimestamp()),
          );
        },
      ),
    );
  }
}
