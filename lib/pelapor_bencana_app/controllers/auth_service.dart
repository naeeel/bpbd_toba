import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static String verifyId = "";

  static Future<void> sentOtp({
    required String phone,
    required Function errorStep,
    required Function nextStep,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        timeout: Duration(seconds: 30),
        phoneNumber: "+62$phone",
        verificationCompleted: (phoneAuthCredential) async {
          // Handling verification completion if needed
          print("Phone number verification completed: $phone");
        },
        verificationFailed: (error) async {
          // Handling verification failure if needed
          print("Phone number verification failed: ${error.message}");
          errorStep();
        },
        codeSent: (verificationId, forceResendingToken) async {
          verifyId = verificationId;
          nextStep();
          print("OTP sent successfully");
        },
        codeAutoRetrievalTimeout: (verificationId) async {
          // Handling code auto retrieval timeout if needed
          print("OTP retrieval timed out");
        },
      );
    } catch (e) {
      // Handle any other errors during phone number verification
      print("Error sending OTP: $e");
      errorStep();
    }
  }

  static Future<String> loginWithOtp({required String otp}) async {
    try {
      final cred = PhoneAuthProvider.credential(
        verificationId: verifyId,
        smsCode: otp,
      );

      final userCredential =
      await _firebaseAuth.signInWithCredential(cred);

      if (userCredential.user != null) {
        print("User successfully logged in with OTP");
        return "Success";
      } else {
        print("Error logging in with OTP");
        return "Error in Otp login";
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException errors
      print("FirebaseAuthException during OTP login: ${e.message}");
      return e.message.toString();
    } catch (e) {
      // Handle other errors
      print("Error during OTP login: $e");
      return e.toString();
    }
  }
}
