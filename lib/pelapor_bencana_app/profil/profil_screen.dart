import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pelaporan_bencana/pelapor_bencana_app/profil/list_akun.dart';
import 'package:pelaporan_bencana/pelapor_bencana_app/profil/report_history_screen.dart';
import 'package:pelaporan_bencana/pelapor_bencana_app/profil/edit_profile_screen.dart';

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
  late String _photoURL = '';
  late List<Report> _userReports = [];

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _membersCollection = FirebaseFirestore.instance.collection('members');

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

        DocumentSnapshot documentSnapshot = await _membersCollection.doc(userId).get();

        if (documentSnapshot.exists) {
          setState(() {
            _firstName = documentSnapshot.get('firstName') ?? '';
            _lastName = documentSnapshot.get('lastName') ?? '';
            _email = documentSnapshot.get('email') ?? '';
            _photoURL = documentSnapshot.get('photoURL') ?? '';
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

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      Navigator.pop(context);
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  Future<void> _refreshData() async {
    await _getUserData();
    await _getUserReports();
  }

  Future<void> _updateProfilePicture(File imageFile) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        // Upload image to Firestore storage or any other storage service
        // and get the download URL
        String imageURL = await uploadImageAndGetURL(imageFile);

        // Update profile photo URL in Firestore with the new imageURL
        await _firestore.collection('members').doc(userId).update({
          'photoURL': imageURL,
        });

        // Update _photoURL with the new imageURL
        setState(() {
          _photoURL = imageURL;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture updated successfully!'),
          ),
        );
      }
    } catch (e) {
      print('Error updating profile picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile picture. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _photoURL.isNotEmpty
                      ? NetworkImage(_photoURL)
                      : AssetImage('assets/images/profile_picture.jpg') as ImageProvider,
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
                  leading: Icon(Icons.edit),
                  title: Text('Edit Profile'),
                  onTap: () async {
                    // Navigate to EditProfileScreen and wait for result
                    File? newImageFile = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(updateProfilePicture: _updateProfilePicture),
                      ),
                    );

                    // If newImageFile is not null (i.e., user selected a new image)
                    if (newImageFile != null) {
                      // Update profile picture
                      _updateProfilePicture(newImageFile);
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.history),
                  title: Text('Historis Pelaporan'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReportHistoryScreen(
                          userReports: _userReports,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.support),
                  title: Text('Tentang Kami'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TentangKamiScreen(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 32),
                TextButton(
                  onPressed: _signOut,
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text('Log Out', style: TextStyle(color: Colors.red)),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
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
