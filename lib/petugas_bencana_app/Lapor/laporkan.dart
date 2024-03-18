import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LaporPage extends StatefulWidget {
  @override
  _LaporPageState createState() => _LaporPageState();
}

class _LaporPageState extends State<LaporPage> {
  String _selectedDisasterType = 'Gempa Bumi';
  File? _pickedImage; // Untuk menyimpan gambar yang dipilih

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
                onTap: () async {
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.getImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _pickedImage = File(pickedFile.path);
                    });
                  }
                },
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
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Keterangan Bencana',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implementasi aksi yang diambil ketika tombol laporkan ditekan
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('Laporkan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
