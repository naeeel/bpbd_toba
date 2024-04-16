import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pelaporan_bencana/petugas_bencana_app/Lapor/location_picker_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laporkan Bencana',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
                onPressed: _isDataSent ? null : () => _submitReport(context),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      _isDataSent ? Colors.grey : Colors.orange),
                  minimumSize: MaterialStateProperty.all<Size>(
                      Size(double.infinity, 50)),
                ),
                child: Text('Laporkan'),
              ),
              SizedBox(height: 10),
              _isDataSent
                  ? Text(
                'Data sudah terkirim!',
                style: TextStyle(color: Colors.green),
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

    // Simpan laporan ke database (dalam contoh ini, laporan tidak disimpan ke database)

    // Tampilkan pesan sukses
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Laporan berhasil dikirim.'),
    ));
    setState(() {
      _isDataSent = true;
    });
  }
}
