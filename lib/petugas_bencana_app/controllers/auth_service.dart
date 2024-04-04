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
        },
        verificationFailed: (error) async {
          // Handling verification failure if needed
          errorStep();
        },
        codeSent: (verificationId, forceResendingToken) async {
          verifyId = verificationId;
          nextStep();
        },
        codeAutoRetrievalTimeout: (verificationId) async {
          // Handling code auto retrieval timeout if needed
        },
      );
    } catch (e) {
      // Handle any other errors during phone number verification
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
        return "Success";
      } else {
        return "Error in Otp login";
      }
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException errors
      return e.message.toString();
    } catch (e) {
      // Handle other errors
      return e.toString();
    }
  }
}
