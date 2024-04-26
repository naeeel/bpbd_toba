import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pelaporan_bencana/petugas_bencana_app/profil/report_history_screen.dart';

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
  late List<Report> _userReports = []; // Menyimpan laporan pengguna

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _getUserData();
    _getUserReports(); // Panggil fungsi untuk mengambil laporan pengguna
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              ListTile(
                leading: Icon(Icons.support),
                title: Text('Tentang Kami'),
                onTap: () {
                  // Handle Support Center tap
                },
              ),
              SizedBox(height: 32),
              TextButton(
                onPressed: () {
                  // Add logout button functionality
                },
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.red), // Mengubah warna ikon
                  title: Text('Log Out', style: TextStyle(color: Colors.red)), // Mengubah warna teks
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
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
