import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPickerMap extends StatefulWidget {
  @override
  _LocationPickerMapState createState() => _LocationPickerMapState();
}

class _LocationPickerMapState extends State<LocationPickerMap> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick Location"),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendLocationToReport,
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _selectedLocation ?? LatLng(2.66687, 98.87571), // Approximate center of Danau Toba
          zoom: 11.0, // Adjusted zoom for broader area
        ),
        markers: _selectedLocation != null
            ? {
                Marker(
                  markerId: MarkerId("selectedLocation"),
                  position: _selectedLocation!,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRed,
                  ),
                ),
              }
            : {},
        onTap: (LatLng latLng) {
          _onMapTap(latLng);
        },
        onMapCreated: (GoogleMapController controller) {
          setState(() {
            _mapController = controller; // Inisialisasi _mapController di sini
          });
        },
      ),
    );
  }

  // Metode untuk menangani ketika peta ditekan
  void _onMapTap(LatLng latLng) {
    // Tentukan batas wilayah yang diizinkan di sekitar Danau Toba
    const double minLat = 2.3;
    const double maxLat = 3.1;
    const double minLon = 98.5;
    const double maxLon = 99.3;

    // Periksa apakah titik yang ditekan berada dalam batasan wilayah yang diizinkan
    if (latLng.latitude >= minLat &&
        latLng.latitude <= maxLat &&
        latLng.longitude >= minLon &&
        latLng.longitude <= maxLon) {
      // Titik yang ditekan berada dalam batasan wilayah yang diizinkan
      setState(() {
        _selectedLocation = latLng;
      });
    } else {
      // Tampilkan pesan kesalahan jika titik yang ditekan diluar batas wilayah yang diizinkan
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Lokasi Tidak Diperbolehkan"),
            content: Text("Anda tidak dapat memilih lokasi di luar wilayah yang diizinkan."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  // Metode untuk menangani ketika tombol Kirim ditekan
  void _sendLocationToReport() {
    if (_selectedLocation != null) {
      Navigator.pop(context, _selectedLocation); // Kirim kembali lokasi ke layar sebelumnya
    }
  }

  // Metode untuk mendapatkan lokasi pengguna saat ini
  void _getCurrentLocation() async {
    // Memeriksa dan meminta izin
    var status = await Permission.location.request();

    if (status == PermissionStatus.granted) {
      try {
        final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _selectedLocation = LatLng(position.latitude, position.longitude);
        });

        // Pusatkan peta ke lokasi pengguna saat ini
        _mapController.animateCamera(
          CameraUpdate.newLatLng(_selectedLocation!),
        );
      } catch (e) {
        print("Error getting location: $e");
      }
    } else {
      // Izin tidak diberikan
      print('Location permission denied.');
    }
  }
}
