import 'package:cloud_firestore/cloud_firestore.dart';

class BeritaService {
  final CollectionReference _beritaRef =
      FirebaseFirestore.instance.collection('berita');

  Future<List<Berita>> getBerita() async {
    try {
      final QuerySnapshot snapshot = await _beritaRef.get();
      return snapshot.docs
          .map((doc) => Berita.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting Berita: $e');
      return [];
    }
  }

  Stream<List<Berita>> getBeritaStream() {
    return _beritaRef.snapshots().map((snapshot) {
      try {
        return snapshot.docs.map((doc) => Berita.fromFirestore(doc)).toList();
      } catch (e) {
        print('Error processing stream data: $e');
        return [];
      }
    });
  }
}

class Berita {
  final String deskripsi;
  final String gambar;
  final String jenisBencana;
  final Timestamp waktuPelaporan;

  Berita({
    required this.deskripsi,
    required this.gambar,
    required this.jenisBencana,
    required this.waktuPelaporan,
  });

  factory Berita.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Berita(
      deskripsi: data['deskripsi'] ?? '',
      gambar: data['gambar'] ?? '',
      jenisBencana: data['jenis_bencana'] ?? '',
      waktuPelaporan: data['waktu_pelaporan'] ?? Timestamp.now(),
    );
  }
}
