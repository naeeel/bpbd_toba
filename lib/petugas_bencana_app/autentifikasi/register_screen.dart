import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pelaporan_bencana/petugas_bencana_app/autentifikasi/list_login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: RegisterScreen(),
  ));
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _nikController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool _agreeToTerms = false;
  bool _obscurePassword = true; // For toggling password visibility
  bool _obscureConfirmPassword = true; // For toggling confirm password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar'),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                'Ayo daftarkan diri anda',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Depan',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama Depan diperlukan';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Belakang',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama Belakang diperlukan';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _nikController,
                      decoration: InputDecoration(
                        labelText: 'NIK',
                        prefixIcon: Icon(Icons.account_box),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'NIK diperlukan';
                        }
                        // You can add more specific validation for NIK if needed
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'E-Mail',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'E-Mail diperlukan';
                        }
                        if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Format Email tidak sesuai';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Nomor Telepon',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(13), // Limiting input to 15 characters
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor Telepon diperlukan';
                        }
                        if (value.length < 10 || value.length > 15) {
                          return 'Nomor telepon tidak sesuai';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Sandi',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kata Sandi diperlukan';
                        }
                        if (value.length < 8) {
                          return 'Kata sandi minimal harus 8 karakter';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Konfirmasi Sandi',
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscureConfirmPassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi Kata Sandi diperlukan';
                        }
                        if (value != _passwordController.text) {
                          return 'Konfirmasi Kata Sandi tidak cocok';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreeToTerms = value!;
                            });
                          },
                        ),
                        Text('I agree to '),
                        GestureDetector(
                          onTap: () {
                            // Navigate to Privacy Policy
                          },
                          child: Text(
                            'Privacy Policy',
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        Text(' and '),
                        GestureDetector(
                          onTap: () {
                            // Navigate to Terms of Use
                          },
                          child: Text(
                            'Terms of Use',
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_passwordController.text !=
                              _confirmPasswordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Konfirmasi Kata Sandi tidak cocok'),
                            ));
                          } else if (!_agreeToTerms) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Anda harus menyetujui Syarat dan Ketentuan'),
                            ));
                          } else {
                            try {
                              // Mendaftarkan pengguna dengan email dan password
                              UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );

                              // Simpan data pengguna ke Firestore
                              await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
                                'firstName': _firstNameController.text,
                                'lastName': _lastNameController.text,
                                'nik': _nikController.text,
                                'email': _emailController.text,
                                'phone': _phoneController.text,
                              });

                              // Navigasi ke halaman ListLoginPage setelah pendaftaran berhasil
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ListLoginPage(),
                                ),
                              );

                              // Tampilkan pesan sukses atau navigasi ke layar lain jika perlu
                            } catch (e) {
                              print('Error registering user: $e');
                              // Tampilkan pesan error jika pendaftaran gagal
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Terjadi kesalahan, silakan coba lagi nanti'),
                              ));
                            }
                          }
                        }
                      },
                      child: Text('Buat Akun'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
