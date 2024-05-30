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
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: report.getStatusIcon(),
              title: Text(report.disasterType),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(report.keterangan),
                  Text(
                      'Lokasi: ${report.latitude}, ${report.longitude}'),
                  Text('Waktu: ${report.getFormattedTimestamp()}'),
                ],
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Optionally, implement navigation to a detailed report screen
              },
            ),
          );
        },
      ),
    );
  }
}
