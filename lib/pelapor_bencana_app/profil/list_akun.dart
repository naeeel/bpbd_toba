import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class TentangKamiScreen extends StatefulWidget {
  @override
  _TentangKamiScreenState createState() => _TentangKamiScreenState();
}

class _TentangKamiScreenState extends State<TentangKamiScreen> {
  List<Map<String, dynamic>> dataList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    DatabaseReference databaseRef = FirebaseDatabase.instance.ref("laravel_expense_ms/users");

    try {
      // Use `DataSnapshot` instead of `DatabaseEvent`
      DataSnapshot snapshot = await databaseRef.once() as DataSnapshot;

      // Handle when the snapshot is empty
      if (!snapshot.exists) {
        print("Database kosong");
        return; // Exit the function if the snapshot is empty
      }

      // Extract user data from the snapshot
      Map<dynamic, dynamic>? userData = snapshot.value as Map<dynamic, dynamic>?;

      // Convert user data to a list of Map<String, dynamic>
      List<Map<String, dynamic>> userList = [];

      if (userData != null) {
        userData.forEach((key, value) {
          userList.add(Map<String, dynamic>.from(value));
        });
      }

      setState(() {
        dataList = userList;
      });
    } catch (error) {
      print("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang Kami'),
      ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text("Nama: ${dataList[index]['firstname']} ${dataList[index]['lastname']}"),
            subtitle: Text("Email: ${dataList[index]['email']}"),
          );
        },
      ),
    );
  }
}
