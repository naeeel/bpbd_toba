import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum ReportStatus { sent, inProgress, completed, rejected }

class Report {
  final String id;
  final String userId;
  final String disasterType;
  final String imagePath;
  final double latitude;
  final double longitude;
  final String keterangan;
  final int timestamp;
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
    return Report(
      id: snapshot.id,
      userId: snapshot['userId'] ?? '',
      disasterType: snapshot['disasterType'] ?? '',
      imagePath: snapshot['imagePath'] ?? '',
      latitude: (snapshot['latitude'] ?? 0.0) as double,
      longitude: (snapshot['longitude'] ?? 0.0) as double,
      keterangan: snapshot['keterangan'] ?? '',
      timestamp: (snapshot['timestamp'] ?? 0) as int,
      status: _getStatusFromString(snapshot['status'] ?? ''),
    );
  }

  static ReportStatus _getStatusFromString(String statusString) {
    switch (statusString) {
      case 'sent':
        return ReportStatus.sent;
      case 'inProgress':
        return ReportStatus.inProgress;
      case 'completed':
        return ReportStatus.completed;
      case 'rejected':
        return ReportStatus.rejected;
      default:
        return ReportStatus.sent;
    }
  }

  Icon getStatusIcon() {
    switch (status) {
      case ReportStatus.sent:
        return Icon(Icons.send);
      case ReportStatus.inProgress:
        return Icon(Icons.hourglass_top);
      case ReportStatus.completed:
        return Icon(Icons.done);
      case ReportStatus.rejected:
        return Icon(Icons.close);
    }
  }
}

class ReportHistoryScreen extends StatelessWidget {
  final List<Report> userReports;

  const ReportHistoryScreen({Key? key, required this.userReports}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historis Pelaporan'),
      ),
      body: userReports.isEmpty
          ? Center(
        child: Text('Tidak ada laporan'),
      )
          : ListView.builder(
        itemCount: userReports.length,
        itemBuilder: (context, index) {
          Report report = userReports[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Card(
              elevation: 4,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportDetailScreen(report: report),
                    ),
                  );
                },
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(report.imagePath),
                    ),
                  ),
                ),
                title: Text(
                  report.disasterType,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Latitude: ${report.latitude}, Longitude: ${report.longitude}',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
                trailing: report.getStatusIcon(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ReportDetailScreen extends StatelessWidget {
  final Report report;

  const ReportDetailScreen({Key? key, required this.report}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Pelaporan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(report.imagePath),
            SizedBox(height: 16),
            Text(
              'Jenis Bencana: ${report.disasterType}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Lokasi Bencana: Latitude: ${report.latitude}, Longitude: ${report.longitude}',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Keterangan: ${report.keterangan}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Status: ${_getStatusText(report.status)}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(ReportStatus status) {
    switch (status) {
      case ReportStatus.sent:
        return 'Terkirim';
      case ReportStatus.inProgress:
        return 'Sedang Diproses';
      case ReportStatus.completed:
        return 'Selesai';
      case ReportStatus.rejected:
        return 'Ditolak';
      default:
        return 'Terkirim';
    }
  }
}

class TrainingScreen extends StatefulWidget {
  const TrainingScreen({Key? key, this.animationController}) : super(key: key);

  final AnimationController? animationController;
  @override
  _TrainingScreenState createState() => _TrainingScreenState();
}

class _TrainingScreenState extends State<TrainingScreen> {
  late String _firstName = '';
  late String _lastName = '';
  late String _email = '';
  late List<Report> _userReports = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _getUserData();
    _getUserReports();
  }

  Future<void> _getUserData() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(userId).get();

        if (documentSnapshot.exists) {
          setState(() {
            _firstName = documentSnapshot.get('firstName') ?? '';
            _lastName = documentSnapshot.get('lastName') ?? '';
            _email = documentSnapshot.get('email') ?? '';
          });
        } else {
          print('Document does not exist');
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> _getUserReports() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        QuerySnapshot querySnapshot = await _firestore
            .collection('laporan')
            .where('userId', isEqualTo: userId)
            .orderBy('timestamp', descending: true)
            .get();

        List<Report> reports = querySnapshot.docs
            .map((doc) => Report.fromSnapshot(doc))
            .toList();

        setState(() {
          _userReports = reports;
        });
      }
    } catch (e) {
      print('Error fetching user reports: $e');
    }
  }

  Future<void> createReport() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        ReportStatus status = ReportStatus.sent;

        await _firestore.collection('laporan').add({
          'userId': userId,
          'disasterType': 'Tipe bencana',
          'imagePath': 'path/to/image.jpg',
          'latitude': 0.0,
          'longitude': 0.0,
          'keterangan': 'Keterangan laporan',
          'timestamp': Timestamp.now().millisecondsSinceEpoch,
          'status': status.toString(),
        });
      }
    } catch (e) {
      print('Error creating report: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/profile_picture.jpg'),
            ),
            SizedBox(height: 16),
            Text(
              '$_firstName $_lastName',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _email,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 32),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                // Handle Profile tap
              },
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('Historis Pelaporan'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportHistoryScreen(userReports: _userReports),
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                createReport();
              },
              child: Text('Buat Laporan'),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TrainingScreen(),
  ));
}
