import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:pelaporan_bencana/pelapor_bencana_app/Lapor/location_picker_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

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
        // Modern theme with a dark blue primary color
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
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold ,fontFamily: 'roboto'),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10),
              Text(
                'Bencana',
                style: TextStyle(fontSize: 25, color: Colors.orange, fontWeight: FontWeight.bold, fontFamily: 'roboto'),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: _isSending ? null : _pickImage,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna putih
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Posisikan item secara merata di sepanjang row
                          children: [
                            Expanded(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    _selectedLocation != null
                                        ? "Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}"
                                        : "Lokasi Bencana",
                                    style: TextStyle(fontSize: 15,  fontFamily: 'Roboto'),
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
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Padding
                          ),
                          style: TextStyle(fontSize: 15, fontFamily: 'Roboto'), // Ganti style teks
                        ),
                      ),
                      SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _isDataSent || _isSending ? null : () => _submitReport(context),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                              _isDataSent || _isSending ? Colors.grey : Colors.orange),
                            minimumSize: MaterialStateProperty.all<Size>(
                              Size(double.infinity, 50)),
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

                    if (pickedLocation != null) {
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
                      // Get a reference to the Firebase Storage
                      final storage = FirebaseStorage.instance;

                      // Create a reference to the image file
                      final ref = storage.ref().child('images/${DateTime.now()}.jpg');

                      // Upload image to Firebase Storage
                      final uploadTask = ref.putFile(_pickedImage!);
                      final snapshot = await uploadTask.whenComplete(() {});

                      // Get download URL
                      final imageURL = await snapshot.ref.getDownloadURL();

                      // Get a reference to the Firestore collection
                      CollectionReference reportsRef =
                      FirebaseFirestore.instance.collection('laporan');

                      // Get current user ID
                      String userId = FirebaseAuth.instance.currentUser!.uid;

                      // Misalnya, inisialisasi status sebagai 'sent' saat membuat laporan baru
                      ReportStatus status = ReportStatus.sent;

                      // Create a new document with a unique ID
                      await reportsRef.add({
                        'userId': userId, // Add user ID to the report data
                        'disasterType': _selectedDisasterType,
                        'imagePath': imageURL, // Add imageURL to the document
                        'latitude': _selectedLocation!.latitude,
                        'longitude': _selectedLocation!.longitude,
                        'keterangan': _keteranganController.text,
                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                        'status': status.toString(), // Add status to the document
                      });

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
                      setState(() {
                        _isDataSent = true;
                      });
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Gagal mengirim laporan: $error',
                            textAlign: TextAlign.center, 
                            style: TextStyle(
                              fontFamily: 'Roboto', 
                            ),
                          ),
                        ),
                      );
                    } finally {
                      setState(() {
                        _isSending = false;
                      });
                    }
                  }

                  void _showDisasterPicker(BuildContext context) {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 200,
                          child: CupertinoPicker(
                            backgroundColor: Colors.white,
                            itemExtent: 40,
                            onSelectedItemChanged: (int index) {
                              setState(() {
                                _selectedDisasterType = _disasterTypes[index];
                              });
                            },
                            children: _disasterTypes.map((String type) {
                              return Center(
                                child: Text(
                                  type,
                                    style: TextStyle(fontSize: 15,  fontFamily: 'Roboto'),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    );
                  }

                  final List<String> _disasterTypes = [
                    'Gempa Bumi',
                    'Banjir',
                    'Kebakaran',
                    'Tanah Longsor',
                    'Gunung Merapi',
                    'Angin Topan',
                    'Tsunami',
                    'Opsi Lainnya'
                  ];
                }

enum ReportStatus { sent, inProgress, completed, rejected }

class Report {
  final String id;
  final String userId;
  final String disasterType;
  final String imagePath; // Field imagePath untuk menyimpan URL gambar
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
      imagePath: snapshot['imagePath'] ?? '', // Mengambil imagePath dari Firestore
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
