import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // Import ImagePicker package

class EditProfileScreen extends StatefulWidget {
  final void Function(File) updateProfilePicture; // Add File parameter

  const EditProfileScreen({Key? key, required this.updateProfilePicture}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late String _firstName = '';
  late String _lastName = '';
  late String _photoURL = '';
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');

  final ImagePicker _picker = ImagePicker(); // Initialize ImagePicker

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        DocumentSnapshot documentSnapshot = await _usersCollection.doc(userId).get();

        if (documentSnapshot.exists) {
          setState(() {
            _firstName = documentSnapshot.get('firstName') ?? '';
            _lastName = documentSnapshot.get('lastName') ?? '';
            _photoURL = documentSnapshot.get('photoURL') ?? ''; // Get profile photo URL
          });

          _firstNameController.text = _firstName;
          _lastNameController.text = _lastName;
        } else {
          print('Document does not exist');
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  // Function to update profile picture
  Future<void> _updateProfilePicture(File imageFile) async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        // Upload image to Firestore storage or any other storage service
        // and get the download URL
        String imageURL = await uploadImageAndGetURL(imageFile);

        // Update profile photo URL in Firestore with the new imageURL
        await _firestore.collection('users').doc(userId).update({
          'photoURL': imageURL,
        });

        // Update _photoURL with the new imageURL
        setState(() {
          _photoURL = imageURL;
        });

        // Call the function passed from TrainingScreen to update profile picture
        widget.updateProfilePicture(imageFile);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture updated successfully!'),
          ),
        );
      }
    } catch (e) {
      print('Error updating profile picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile picture. Please try again.'),
        ),
      );
    }
  }

  // Function to pick image from gallery
  Future<void> _getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery); // Use pickImage instead of getImage
    setState(() {
      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
        _updateProfilePicture(imageFile); // Call function to update profile picture
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _updateProfile() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        await _firestore.collection('users').doc(userId).update({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'photoURL': _photoURL,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully!'),
          ),
        );
      }
    } catch (e) {
      print('Error updating profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile. Please try again.'),
        ),
      );
    }
  }

  Future<void> _updatePassword() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        await user.updatePassword(_newPasswordController.text);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password updated successfully!'),
          ),
        );
      }
    } catch (e) {
      print('Error updating password: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update password. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: _photoURL.isNotEmpty
                  ? NetworkImage(_photoURL)
                  : AssetImage('assets/images/profile_picture.jpg') as ImageProvider,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
              ),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Current Password',
              ),
              obscureText: !_isPasswordVisible,
            ),
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
              ),
              obscureText: !_isNewPasswordVisible,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
              ),
              obscureText: !_isConfirmPasswordVisible,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Update Profile'),
            ),
            ElevatedButton(
              onPressed: _updatePassword,
              child: Text('Update Password'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getImageFromGallery, // Call function to pick image from gallery
              child: Text('Change Profile Picture'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String> uploadImageAndGetURL(File imageFile) async {
  // Add your image upload logic here
  // Return the download URL of the uploaded image
  return ''; // Return empty string as default value
}
