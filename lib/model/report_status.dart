import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Define the ReportStatus enum and Report class
enum ReportStatus { sent, inProgress, completed, rejected }

class Report {
  final String id;
  final String userId;
  final String disasterType;
  final String imagePath;
  final double latitude;
  final double longitude;
  final String keterangan;
  final Timestamp timestamp;
  final ReportStatus status;

  Report({
    required this.id,
    required this.userId,
    required this.disasterType,
    required this.imagePath,
    required this.latitude,
    required this.longitude,
    required this.keterangan,
    required this.timestamp,
    required this.status,
  });

  factory Report.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return Report(
      id: snapshot.id,
      userId: data['userId'] ?? '',
      disasterType: data['disasterType'] ?? '',
      imagePath: data['imageUrl'] ?? '',
      latitude: (data['location'] as GeoPoint).latitude,
      longitude: (data['location'] as GeoPoint).longitude,
      keterangan: data['description'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      status: ReportStatus.values.firstWhere(
            (e) => e.toString() == 'ReportStatus.${data['status'] ?? 'sent'}',
        orElse: () => ReportStatus.sent,
      ),
    );
  }

  Icon getStatusIcon() {
    switch (status) {
      case ReportStatus.sent:
        return Icon(Icons.send, color: Colors.blue);
      case ReportStatus.inProgress:
        return Icon(Icons.hourglass_top, color: Colors.orange);
      case ReportStatus.completed:
        return Icon(Icons.done, color: Colors.green);
      case ReportStatus.rejected:
        return Icon(Icons.close, color: Colors.red);
    }
  }

  String getFormattedTimestamp() {
    final DateTime date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }

  static Future<List<Report>> fetchReports(String userId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('laporan')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => Report.fromSnapshot(doc)).toList();
    } catch (e) {
      print('Error fetching user reports: $e');
      return [];
    }
  }
}

// Define the ReportHistoryScreen widget
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

// Define the StatefulWidget to fetch user reports
class ReportHistoryPage extends StatefulWidget {
  final String userId;

  ReportHistoryPage({required this.userId});

  @override
  _ReportHistoryPageState createState() => _ReportHistoryPageState();
}

class _ReportHistoryPageState extends State<ReportHistoryPage> {
  List<Report> _userReports = [];

  @override
  void initState() {
    super.initState();
    _fetchUserReports();
  }

  Future<void> _fetchUserReports() async {
    List<Report> reports = await Report.fetchReports(widget.userId);
    setState(() {
      _userReports = reports;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReportHistoryScreen(userReports: _userReports);
  }
}

// Usage:
void main() {
  runApp(MaterialApp(
    home: ReportHistoryPage(userId: 'user123'), // Replace 'user123' with actual userId
  ));
}
