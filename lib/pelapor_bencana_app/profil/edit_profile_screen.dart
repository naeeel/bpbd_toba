import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final void Function(File) updateProfilePicture;

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
  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _membersCollection = FirebaseFirestore.instance.collection('members');

  final ImagePicker _picker = ImagePicker();

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

        DocumentSnapshot documentSnapshot = await _membersCollection.doc(userId).get();

        if (documentSnapshot.exists) {
          setState(() {
            _firstName = documentSnapshot.get('firstName') ?? '';
            _lastName = documentSnapshot.get('lastName') ?? '';
            _photoURL = documentSnapshot.get('photoURL') ?? '';
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

  Future<void> _updateProfilePicture(File imageFile) async {
    try {
      setState(() {
        _isLoading = true;
      });

      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        String imageURL = await uploadImageAndGetURL(imageFile);

        await _firestore.collection('members').doc(userId).update({
          'photoURL': imageURL,
        });

        setState(() {
          _photoURL = imageURL;
          _isLoading = false;
        });

        widget.updateProfilePicture(imageFile);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile picture updated successfully!'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      print('Error updating profile picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile picture. Please try again.'),
        ),
      );
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      _updateProfilePicture(imageFile);
    } else {
      print('No image selected.');
    }
  }

  Future<void> _captureImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      _updateProfilePicture(imageFile);
    } else {
      print('No image captured.');
    }
  }

  Future<void> _updateProfile() async {
    try {
      setState(() {
        _isLoading = true;
      });

      User? user = _auth.currentUser;

      if (user != null) {
        String userId = user.uid;

        await _firestore.collection('members').doc(userId).update({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'photoURL': _photoURL,
        });

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully!'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

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
      setState(() {
        _isLoading = true;
      });

      User? user = _auth.currentUser;

      if (user != null) {
        await user.updatePassword(_newPasswordController.text);

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password updated successfully!'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

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
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _photoURL.isNotEmpty
                        ? NetworkImage(_photoURL)
                        : AssetImage('assets/images/profile_picture.jpg') as ImageProvider,
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: _getImageFromGallery,
                  ),
                  IconButton(
                    icon: Icon(Icons.camera),
                    onPressed: _captureImageFromCamera,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Current Password',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_isPasswordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your current password';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(Icons.lock_open),
                suffixIcon: IconButton(
                  icon: Icon(_isNewPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isNewPasswordVisible = !_isNewPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_isNewPasswordVisible,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a new password';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_isConfirmPasswordVisible,
              validator: (value) {
                if (value != _newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _updateProfile,
                  child: Text('Update Profile'),
                ),
                ElevatedButton(
                  onPressed: _updatePassword,
                  child: Text('Update Password'),
                ),
              ],
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
