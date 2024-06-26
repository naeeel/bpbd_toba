import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:pelaporan_bencana/pelapor_bencana_app/Lapor/location_picker_map.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LaporApp());
}

class LaporApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laporan Bencana',
      theme: ThemeData(
        primaryColor: Colors.blue[800],
        scaffoldBackgroundColor: Colors.grey[100],
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.orange,
        ),
        appBarTheme: AppBarTheme(
          color: Colors.blue[800],
        ),
      ),
      home: LaporPage(),
    );
  }
}

class LaporPage extends StatefulWidget {
  @override
  _LaporPageState createState() => _LaporPageState();
}

class _LaporPageState extends State<LaporPage> {
  String _selectedDisasterType = 'Gempa Bumi';
  File? _pickedImage;
  LatLng? _selectedLocation;
  final TextEditingController _keteranganController = TextEditingController();
  bool _isDataSent = false;
  bool _isSending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporkan Kejadian'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Laporkan Kejadian',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10),
              Text(
                'Bencana',
                style: TextStyle(fontSize: 25, color: Colors.orange, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: _isSending ? null : _pickImage,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.10),
                        spreadRadius: 6,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: _pickedImage != null
                        ? Image.file(_pickedImage!)
                        : Icon(Icons.camera_alt, size: 40, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Masukkan Keterangan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => _showDisasterPicker(context),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.10),
                        spreadRadius: 6,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _selectedDisasterType,
                      style: TextStyle(fontSize: 15, fontFamily: 'Roboto'),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () => _pickLocation(context),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.10),
                        spreadRadius: 6,
                        blurRadius: 3,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              _selectedLocation != null
                                  ? "Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}"
                                  : "Lokasi Bencana",
                              style: TextStyle(fontSize: 15, fontFamily: 'Roboto'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.10),
                      spreadRadius: 6,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _keteranganController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Keterangan Bencana',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  ),
                  style: TextStyle(fontSize: 15, fontFamily: 'Roboto'),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isDataSent || _isSending ? null : () => _submitReport(context),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      _isDataSent || _isSending ? Colors.grey : Colors.orange),
                  minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 50)),
                ),
                child: _isSending
                    ? CircularProgressIndicator()
                    : Text(
                  'Laporkan',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              SizedBox(height: 10),
              _isDataSent
                  ? Text(
                'Data sudah terkirim!',
                style: TextStyle(fontFamily: 'Roboto', color: Colors.green),
              )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickLocation(BuildContext context) async {
    LatLng? pickedLocation = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerMap(),
      ),
    );

    if (pickedLocation != null && mounted) {
      setState(() {
        _selectedLocation = pickedLocation;
      });
    }
  }

  Future<void> _submitReport(BuildContext context) async {
    if (_pickedImage == null ||
        _selectedLocation == null ||
        _keteranganController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Harap lengkapi semua informasi.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
            ),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final storage = FirebaseStorage.instance;
        final imageId = DateTime.now().millisecondsSinceEpoch.toString(); // Unique ID for the image
        final ref = storage.ref().child('images/$imageId.jpg');
        final uploadTask = ref.putFile(_pickedImage!);
        final snapshot = await uploadTask.whenComplete(() => {});
        final imageUrl = await snapshot.ref.getDownloadURL();

        final userQuerySnapshot = await FirebaseFirestore.instance
            .collection('members')
            .where('email', isEqualTo: user.email)
            .get();

        if (userQuerySnapshot.docs.isNotEmpty) {
          final userDoc = userQuerySnapshot.docs.first;
          final userData = userDoc.data();

          final firstName = userData['firstName'] as String;
          final lastName = userData['lastName'] as String;
          final userId = '$firstName$lastName';
          final currentTimestamp = DateTime.now();
          final timestamp = Timestamp.fromDate(currentTimestamp); // Store the timestamp as a Timestamp

          await FirebaseFirestore.instance.collection('laporan').add({
            'userId': userId,
            'imageUrl': imageUrl,
            'disasterType': _selectedDisasterType,
            'description': _keteranganController.text,
            'location': GeoPoint(_selectedLocation!.latitude, _selectedLocation!.longitude),
            'timestamp': timestamp, // Menyimpan timestamp sebagai Timestamp
          });

          if (!mounted) return;  // Check if widget is still mounted before updating the state
          setState(() {
            _isDataSent = true;
            _pickedImage = null;
            _selectedLocation = null;
            _keteranganController.clear();
          });

          final formattedDateTime = DateFormat.yMMMMd().add_jm().add_jms().format(currentTimestamp) + ' UTC+7';
          print('timestamp $formattedDateTime');

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Laporan berhasil dikirim.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Data pengguna tidak ditemukan di Firestore.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Roboto',
                ),
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Pengguna belum masuk.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
              ),
            ),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Terjadi kesalahan saat mengirim laporan.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Roboto',
            ),
          ),
        ),
      );
    } finally {
      if (!mounted) return;  // Check if widget is still mounted before updating the state
      setState(() {
        _isSending = false;
      });
    }
  }

  void _showDisasterPicker(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Pilih Jenis Bencana'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            child: const Text('Gempa Bumi'),
            onPressed: () {
              setState(() {
                _selectedDisasterType = 'Gempa Bumi';
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Tsunami'),
            onPressed: () {
              setState(() {
                _selectedDisasterType = 'Tsunami';
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Banjir'),
            onPressed: () {
              setState(() {
                _selectedDisasterType = 'Banjir';
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Tanah Longsor'),
            onPressed: () {
              setState(() {
                _selectedDisasterType = 'Tanah Longsor';
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Kebakaran Hutan'),
            onPressed: () {
              setState(() {
                _selectedDisasterType = 'Kebakaran Hutan';
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Kebakaran Hutan'),
            onPressed: () {
              setState(() {
                _selectedDisasterType = 'Kebakaran Hutan';
              });
              Navigator.pop(context);
            },
          ),  
          CupertinoActionSheetAction(
            child: const Text('Badai'),
            onPressed: () {
              setState(() {
                _selectedDisasterType = 'Badai';
              });
              Navigator.pop(context);
            },
          ),                  
        ],
        cancelButton: CupertinoActionSheetAction(
          child: const Text('Batal'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

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
    return Report(
      id: snapshot.id,
      userId: snapshot['userId'] ?? '',
      disasterType: snapshot['disasterType'] ?? '',
      imagePath: snapshot['imageUrl'] ?? '',
      latitude: (snapshot['location'].latitude ?? 0.0) as double,
      longitude: (snapshot['location'].longitude ?? 0.0) as double,
      keterangan: snapshot['description'] ?? '',
      timestamp: snapshot['timestamp'] ?? Timestamp.now(),
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

enum ReportStatus {
  sent,
  inProgress,
  completed,
  rejected,
}

void displayReport(DocumentSnapshot snapshot) {
  final report = Report.fromSnapshot(snapshot);

  final DateTime dateTime = report.timestamp.toDate();
  final String formattedDateTime = DateFormat.yMMMMd().add_jm().add_jms().format(dateTime) + ' UTC+7';

  print('description: ${report.keterangan}');
  print('disasterType: ${report.disasterType}');
  print('imageUrl: ${report.imagePath}');
  print('location: [${report.latitude}° N, ${report.longitude}° E]');
  print('timestamp: $formattedDateTime');
  print('userId: ${report.userId}');
}
