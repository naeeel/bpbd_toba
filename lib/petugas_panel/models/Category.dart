import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final CollectionReference _categoriesRef =
      FirebaseFirestore.instance.collection('laporan');

  Future<List<Category>> getCategories() async {
    try {
      final QuerySnapshot snapshot = await _categoriesRef.get();
      return snapshot.docs
          .map((doc) => Category.fromFirestore(doc))
          .toList();
    } catch (e) {
      // Handle error, e.g., print error or return an empty list
      print('Error getting categories: $e');
      return [];
    }
  }

  Stream<List<Category>> getCategoriesStream() {
    return _categoriesRef.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList());
  }
}

class Category {
  String id;
  final String description;
  final String disasterType;
  final String imageUrl;
  final GeoPoint location;
  final Timestamp timestamp;
  final String userId;

  Category({
    required this.id,
    required this.description,
    required this.disasterType,
    required this.imageUrl,
    required this.location,
    required this.timestamp,
    required this.userId,
  });

  factory Category.fromFirestore(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Category(
      id: snapshot.id,
      description: data['description'],
      disasterType: data['disasterType'],
      imageUrl: data['imageUrl'],
      location: data['location'],
      timestamp: data['timestamp'],
      userId: data['userId'],
    );
  }
}

