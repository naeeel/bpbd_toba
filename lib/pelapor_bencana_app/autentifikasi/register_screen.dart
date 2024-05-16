import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pelaporan_bencana/pelapor_bencana_app/autentifikasi/list_login_screen.dart';

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
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
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
                    _buildTextFormField(
                      controller: _firstNameController,
                      labelText: 'Nama Depan',
                      prefixIcon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama Depan diperlukan';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    _buildTextFormField(
                      controller: _lastNameController,
                      labelText: 'Nama Belakang',
                      prefixIcon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama Belakang diperlukan';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    _buildTextFormField(
                      controller: _nikController,
                      labelText: 'NIK',
                      prefixIcon: Icons.account_box,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
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
                    _buildTextFormField(
                      controller: _emailController,
                      labelText: 'E-Mail',
                      prefixIcon: Icons.email,
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
                    _buildTextFormField(
                      controller: _phoneController,
                      labelText: 'Nomor Telepon',
                      prefixText: '+62 ', // Added prefix text
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        // Menghapus prefiks "+62 " sebelum melakukan validasi
                        String phoneNumber = value!.replaceAll("+62 ", "");
                        if (phoneNumber.isEmpty) {
                          return "Masukkan nomor telepon anda dengan benar";
                        }
                        if (phoneNumber.length < 11 || phoneNumber.length > 15) {
                          return "Nomor telepon tidak valid";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    _buildTextFormField(
                      controller: _passwordController,
                      labelText: 'Sandi',
                      prefixIcon: Icons.lock,
                      suffixIcon: _buildSuffixIcon(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
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
                    _buildTextFormField(
                      controller: _confirmPasswordController,
                      labelText: 'Konfirmasi Sandi',
                      prefixIcon: Icons.lock,
                      suffixIcon: _buildSuffixIcon(
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword =
                            !_obscureConfirmPassword;
                          });
                        },
                        icon: _obscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
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
                        Text('Saya menyetujui '),
                        GestureDetector(
                          onTap: () {
                            // Navigate to Privacy Policy
                          },
                          child: Text(
                            'Kebijakan Privasi',
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        Text(' dan '),
                        GestureDetector(
                          onTap: () {
                            // Navigate to Terms of Use
                          },
                          child: Text(
                            'Syarat Penggunaan',
                            style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text('Buat Akun'),
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

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Konfirmasi Kata Sandi tidak cocok'),
        ));
      } else if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Anda harus menyetujui Syarat dan Ketentuan'),
        ));
      } else {
        setState(() {
          _isLoading = true;
        });
        try {
          UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text,
          );

          await FirebaseFirestore.instance
              .collection('members')
              .doc(userCredential.user!.uid)
              .set({
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'nik': _nikController.text,
            'email': _emailController.text,
            'phone': _phoneController.text.replaceAll("+62 ", ""), // Removed prefix text
          });

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ListLoginPage(),
            ),
          );
        } catch (e) {
          print('Error registering user: $e');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
            Text('Terjadi kesalahan, silakan coba lagi nanti'),
          ));
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    Widget? suffixIcon, // Changed the type to Widget?
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? prefixText,
    required String? Function(String?) validator,
    bool obscureText = false,
    void Function()? onSuffixIconPressed,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon != null
            ? IconButton(
          icon: suffixIcon,
          onPressed: onSuffixIconPressed,
        )
            : null,
        prefixText: prefixText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      obscureText: obscureText,
    );
  }

  Widget _buildSuffixIcon({
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
    );
  }
}
