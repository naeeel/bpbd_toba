import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final CollectionReference _categoriesRef =
      FirebaseFirestore.instance.collection('laporan');

  Future<List<Category>> getCategories() async {
    final QuerySnapshot snapshot = await _categoriesRef.get();
    return snapshot.docs
        .map((doc) => Category.fromFirestore(doc))
        .toList();
  }

  // Tambahkan metode ini
  Stream<List<Category>> getCategoriesStream() {
    return _categoriesRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList());
  }
}

class Category {
  String title;
  String imagePath;
  String description;
  String disasterType;
  String keterangan;
  double latitude;
  double longitude;
  String status;
  int timestamp;
  String userId;

  Category({
    this.title = '',
    this.imagePath = '',
    this.description = '',
    this.disasterType = '',
    this.keterangan = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.status = '',
    this.timestamp = 0,
    this.userId = '',
  });

  // Rename the method to match the actual implementation
  static Category fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Category(
      title: data['title'] ?? '',
      imagePath: data['imagePath'] ?? '',
      description: data['description'] ?? '',
      disasterType: data['disasterType'] ?? '',
      keterangan: data['keterangan'] ?? '',
      latitude: (data['latitude'] != null) ? data['latitude'].toDouble() : 0.0,
      longitude: (data['longitude'] != null) ? data['longitude'].toDouble() : 0.0,
      status: data['status'] ?? '',
      timestamp: data['timestamp'] ?? 0,
      userId: data['userId'] ?? '',
    );
  }
}
