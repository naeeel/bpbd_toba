
import 'package:flutter/material.dart';
import 'package:pelaporan_bencana/petugas_bencana_app/controllers/auth_service.dart';
import 'package:pelaporan_bencana/petugas_bencana_app/pelaporan_bencana_app_home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  void listenToIncomingSMS(BuildContext context) {
    print("Listening to sms.");
    // Add your implementation to listen for incoming SMS here
  }

  void handleSubmit(BuildContext context) {
    if (_formKey1.currentState!.validate()) {
      AuthService.loginWithOtp(otp: _otpController.text).then((value) {
        if (value == "Success") {
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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              "Welcome Back",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
                    Text(
                      "masukkan nomor telepon kamu yaa!!",
                      
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
                          if (value!.isEmpty || !value.startsWith("8")) {
                            return "masukkan nomor telepon anda dengan benar";
                          }
                          if (value.length < 11 || value.length > 13) {
                            return "Invalid phone number";
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            AuthService.sentOtp(
                              phone: _phoneController.text,
                              errorStep: () => ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Error in sending OTP",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              ),
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
                          }
                        },
                        child: Text("Send OTP"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF28920),
                          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
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
