import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelaporan_bencana/pelapor_bencana_app/pelaporan_bencana_app_home_screen.dart';
import 'package:pelaporan_bencana/pelapor_bencana_app/pelaporan_bencana_app_theme.dart';
import 'package:pelaporan_bencana/petugas_panel/home_design_laporan.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signInWithEmailAndPassword({required String email, required String password, bool rememberMe = false}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (rememberMe) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setBool('rememberMe', true);
      }
      return "Success";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        return 'Email atau kata sandi salah';
      } else {
        return 'Terjadi kesalahan. Silakan coba lagi.';
      }
    } catch (e) {
      return 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }
}

class EmailLoginPage extends StatefulWidget {
  @override
  _EmailLoginPageState createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _getRememberMeStatus();
  }

  Future<void> _getRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool rememberMe = prefs.getBool('rememberMe') ?? false;
    if (rememberMe) {
      String? savedEmail = prefs.getString('email');
      if (savedEmail != null) {
        setState(() {
          _emailController.text = savedEmail;
          _rememberMe = true;
        });
      }
    }
  }

  Future<bool> _isOfficer(String email) async {
    CollectionReference officersRef = FirebaseFirestore.instance.collection('users');
    QuerySnapshot officersSnapshot = await officersRef.where('email', isEqualTo: email).get();
    return officersSnapshot.docs.isNotEmpty;
  }

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      AuthService().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
        rememberMe: _rememberMe,
      ).then((value) async {
        if (value == "Success") {
          bool isOfficer = await _isOfficer(_emailController.text);
          if (isOfficer) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => DesignCourseHomeScreen(),
              ),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PelaporansAppHomeScreen(),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                value,
                style: PelaporansAppTheme.body2.copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Selamat Datang",
                      textAlign: TextAlign.center,
                      style: PelaporansAppTheme.headline.copyWith(
                        fontSize: 32,
                        letterSpacing: -0.1,
                        color: PelaporansAppTheme.dark_grey,
                      ),
                    ),
                    Text(
                      "Masukkan email dan password kamu ya!",
                      textAlign: TextAlign.center,
                      style: PelaporansAppTheme.body2.copyWith(color: PelaporansAppTheme.grey),
                    ),
                    SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: PelaporansAppTheme.caption.copyWith(color: PelaporansAppTheme.lightText),
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: PelaporansAppTheme.body2.copyWith(color: PelaporansAppTheme.grey),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Email tidak boleh kosong";
                                } else if (!value.contains("@")) {
                                  return "Masukkan alamat email yang benar";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Kata Sandi",
                                labelStyle: PelaporansAppTheme.caption.copyWith(color: PelaporansAppTheme.lightText),
                                filled: true,
                                fillColor: Colors.grey[200],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: PelaporansAppTheme.body2.copyWith(color: PelaporansAppTheme.grey),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Kata sandi tidak boleh kosong";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                        ),
                        Text(
                          'Ingatkan Saya',
                          style: PelaporansAppTheme.body2,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: ElevatedButton(
                        onPressed: () => _handleSubmit(context),
                        child: Text(
                          "Masuk",
                          style: PelaporansAppTheme.body2.copyWith(color: PelaporansAppTheme.spacer),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: PelaporansAppTheme.nearlyBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Implementasi logika untuk lupa kata sandi
                      },
                      child: Text(
                        "Lupa Kata Sandi?",
                        style: PelaporansAppTheme.body2.copyWith(color: PelaporansAppTheme.nearlyDarkBlue),
                      ),
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

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      textTheme: PelaporansAppTheme.textTheme,
    ),
    home: EmailLoginPage(),
  ));
}
