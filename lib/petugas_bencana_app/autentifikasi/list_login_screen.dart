import 'package:flutter/material.dart';
import 'package:pelaporan_bencana/petugas_bencana_app/autentifikasi/email_login_screen.dart';
import 'package:pelaporan_bencana/petugas_bencana_app/autentifikasi/phone_login_screen.dart';

class ListLoginPage extends StatelessWidget {
  void handleEmailLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmailLoginPage()),
    );
  }

  void handlePhoneLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PhoneLoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Masuk'),
        // Tambahkan tombol kembali di sini
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                child: Image.asset(
                  "assets/pelaporan_app/log-in.png",
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Masuk ke RESQUBE",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        // Handle masuk dengan email
                        print('Masuk dengan email');
                        handleEmailLogin(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.email),
                            SizedBox(width: 10),
                            Text(
                              'Masuk dengan Email',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        // Handle masuk dengan nomor telepon
                        print('Masuk dengan nomor telepon');
                        handlePhoneLogin(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey[200],
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.phone),
                            SizedBox(width: 10),
                            Text(
                              'Masuk dengan Nomor Telepon',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
