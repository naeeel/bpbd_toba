import 'package:flutter/material.dart';
import 'package:pelaporan_bencana/pelapor_bencana_app/controllers/auth_service.dart';
import 'package:pelaporan_bencana/pelapor_bencana_app/pelaporan_bencana_app_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({Key? key}) : super(key: key);

  @override
  State<PhoneLoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<PhoneLoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  bool _rememberMe = false;

  void listenToIncomingSMS(BuildContext context) {
    print("Listening to sms.");
    // Add your implementation to listen for incoming SMS here
  }

  void handleSubmit(BuildContext context) {
    if (_formKey1.currentState!.validate()) {
      AuthService.loginWithOtp(otp: _otpController.text).then((value) {
        if (value == "Success") {
          // Add the phone number to the database
          addPhoneNumberToDatabase(_phoneController.text);

          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PelaporansAppHomeScreen(),
            ),
          );
        } else {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              value,
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ));
        }
      });
    }
  }

  // Function to add the phone number to the Firestore database
  void addPhoneNumberToDatabase(String phoneNumber) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'phone': phoneNumber,
      });
    }
  }

  // Function to check if the phone number is already registered
  Future<bool> isPhoneNumberRegistered(String phoneNumber) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: phoneNumber.replaceAll("+62 ", ""))
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _getRememberMeStatus();
  }

  Future<void> _getRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('phoneRememberMe') ?? false;
    setState(() {
      _rememberMe = rememberMe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Masuk dengan Nomor Telepon'),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200, // Atur lebar sesuai kebutuhan
                height: 200, // Atur tinggi sesuai kebutuhan
                child: Image.asset(
                  "assets/pelaporan_app/log-in.png",
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 40.0), // Mengatur margin bottom
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Mengatur kolom menjadi rata tengah
                  children: [
                    Text(
                      "Selamat Datang",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Masukkan nomor telepon kamu!",
                      textAlign: TextAlign.center, // Mengatur teks menjadi rata tengah
                    ),
                    SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          prefixText: "+62 ",
                          labelText: "Masukkan nomor telepon",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Masukkan nomor telepon anda dengan benar";
                          }
                          if (value.length < 11 || value.length > 15) {
                            return "Nomor telepon tidak valid";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            bool isRegistered =
                            await isPhoneNumberRegistered(_phoneController.text);
                            if (isRegistered) {
                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              if (_rememberMe) {
                                await prefs.setBool('phoneRememberMe', true);
                              } else {
                                await prefs.remove('phoneRememberMe');
                              }

                              AuthService.sentOtp(
                                phone: _phoneController.text,
                                errorStep: () => ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    "Error in sending OTP",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                )),
                                nextStep: () {
                                  listenToIncomingSMS(context);
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("OTP Verification"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Enter 6 digit OTP"),
                                          SizedBox(height: 12),
                                          Form(
                                            key: _formKey1,
                                            child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              controller: _otpController,
                                              decoration: InputDecoration(
                                                labelText: "Enter your OTP",
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(32),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value!.length != 6) return "Invalid OTP";
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => handleSubmit(context),
                                          child: Text("Submit"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  "Nomor anda belum terdaftar, lakukan pendaftaran dahulu",
                                  style: TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.red,
                              ));
                            }
                          }
                        },
                        child: Text("Send OTP"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF28920),
                          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (bool? value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                        ),
                        Text("Ingatkan Saya"),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
