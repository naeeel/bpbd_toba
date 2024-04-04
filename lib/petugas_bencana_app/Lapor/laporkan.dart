import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pelaporan_bencana/petugas_bencana_app/Lapor/location_picker_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Realtime Database

class LaporPage extends StatefulWidget {
  @override
  _LaporPageState createState() => _LaporPageState();
}

class _LaporPageState extends State<LaporPage> {
  String _selectedDisasterType = 'Gempa Bumi';
  File? _pickedImage;
  LatLng? _selectedLocation;
  final TextEditingController _keteranganController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporkan Kejadian'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Laporkan Kejadian',
                style: TextStyle(fontSize: 25),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10),
              Text(
                'Bencana',
                style: TextStyle(fontSize: 25, color: Colors.orange),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: _pickImage,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  color: Colors.grey[200],
                  child: Center(
                    child: _pickedImage != null
                        ? Image.file(_pickedImage!)
                        : Text('Foto', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Masukkan Keterangan',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Jenis Bencana',
                  border: OutlineInputBorder(),
                ),
                value: _selectedDisasterType,
                onChanged: (value) {
                  setState(() {
                    _selectedDisasterType = value!;
                  });
                },
                items: <String>[
                  'Gempa Bumi',
                  'Banjir',
                  'Kebakaran',
                  'Tanah Longsor',
                  'Gunung Merapi',
                  'Angin Topan',
                  'Tsunami',
                  'Opsi Lainnya'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Lokasi Bencana',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.location_on),
                    onPressed: () => _pickLocation(context),
                  ),
                ),
                readOnly: true,
                controller: TextEditingController(
                    text: _selectedLocation != null
                        ? "Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}"
                        : null),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _keteranganController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Keterangan Bencana',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitReport(context),
                style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.orange),
                  minimumSize: MaterialStateProperty.all<Size>(
                      Size(double.infinity, 50)),
                ),
                child: Text('Laporkan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedFile =
    await picker.pickImage(source: ImageSource.camera);
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

  void _submitReport(BuildContext context) {
    if (_pickedImage == null ||
        _selectedLocation == null ||
        _keteranganController.text.isEmpty) {
      // Tampilkan pesan kesalahan jika ada field yang kosong
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Harap lengkapi semua informasi.'),
      ));
      return;
    }

    // Referensi database Firebase
    DatabaseReference databaseRef = FirebaseDatabase.instance.reference();

    // Buat objek laporan
    Map<String, dynamic> reportData = {
      'jenis_bencana': _selectedDisasterType,
      'lokasi': {
        'latitude': _selectedLocation!.latitude,
        'longitude': _selectedLocation!.longitude,
      },
      'keterangan': _keteranganController.text,
    };

    // Simpan laporan ke database
    databaseRef.child('laporan').push().set(reportData).then((_) {
      // Tampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Laporan berhasil dikirim.'),
      ));
    }).catchError((error) {
      // Tampilkan pesan error jika gagal mengirimkan laporan
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Terjadi kesalahan saat menyimpan laporan: $error'),
      ));
    });
  }
}
