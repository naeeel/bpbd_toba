import 'package:flutter/material.dart';
import 'package:pelaporan_bencana/petugas_bencana_app/pelaporan_bencana_app_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signInWithEmailAndPassword({required String email, required String password, bool rememberMe = false}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // Simpan status "Ingatkan Saya" jika ditandai
      if (rememberMe) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email); // Simpan email ke SharedPreferences
        await prefs.setBool('rememberMe', true);
      }
      return "Success";
    } catch (e) {
      return e.toString();
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
          _emailController.text = savedEmail; // Set email yang disimpan ke dalam text field
          _rememberMe = true;
        });
      }
    }
  }

  void _handleSubmit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      AuthService().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
        rememberMe: _rememberMe, // Kirim status "Ingatkan Saya"
      ).then((value) {
        if (value == "Success") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PelaporansAppHomeScreen(),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                value,
                style: TextStyle(color: Colors.white),
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
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Masukkan email dan password kamu ya!",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty || !value.contains("@")) {
                                return "Masukkan alamat email yang benar";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Kata Sandi",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Masukkan kata sandi yang benar";
                              }
                              return null;
                            },
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
                        Text('Ingatkan Saya'),
                      ],
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _handleSubmit(context),
                        child: Text("Masuk"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF28920),
                          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                    TextButton( // Fitur tambahan untuk lupa kata sandi
                      onPressed: () {
                        // Implementasi logika untuk lupa kata sandi
                      },
                      child: Text(
                        "Lupa Kata Sandi?",
                        style: TextStyle(
                          color: Colors.blue,
                        ),
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
