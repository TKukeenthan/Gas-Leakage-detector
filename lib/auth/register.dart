// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../chatUser.dart';
import 'reusable_widget.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _repasswordTextController =
      TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _firstNameTextController =
      TextEditingController();
  final TextEditingController _lastNameTextController = TextEditingController();
  final TextEditingController _streetTextController = TextEditingController();
  final TextEditingController _street2TextController = TextEditingController();
  final TextEditingController _cityTextController = TextEditingController();
  final TextEditingController _postalCodeTextController =
      TextEditingController();
  final TextEditingController _mobileNumberTextController =
      TextEditingController();
  File? _image;

  void _registerUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailTextController.text,
              password: _passwordTextController.text);

      if (userCredential.user != null) {
        String imageUrl = '';
        if (_image != null) {
          // Upload image to Firebase Storage
          Reference ref = FirebaseStorage.instance
              .ref()
              .child('profile_images')
              .child(userCredential.user!.uid);
          UploadTask uploadTask = ref.putFile(_image!);
          TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
          imageUrl = await taskSnapshot.ref.getDownloadURL();
        }

        ChatUser chatUser = ChatUser(
          id: userCredential.user!.uid,
          name: _firstNameTextController.text,
          email: _emailTextController.text,
          about: "Hey, I'm using gld Chat!",
          image: imageUrl,
          createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
          isOnline: false,
          lastActive: DateTime.now().millisecondsSinceEpoch.toString(),
          pushToken: '',
          mobile_number: _mobileNumberTextController.text,
          address: {
            'street': _streetTextController.text,
            'street2': _street2TextController.text,
            'city': _cityTextController.text,
            'postalCode': _postalCodeTextController.text,
          },
          home_location: {
            'latitude': '',
            'longitude': '',
          },
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set(chatUser.toJson());

        Navigator.pushNamed(context, 'RegisterHomeLocation');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          print('The password provided is too weak.');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("The password provided is too weak."),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print('The account already exists for that email.');
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("The account already exists for that email."),
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 37, 37),
      body: Padding(
        padding: const EdgeInsets.only(left: 35, top: 35),
        child: Column(
          children: [
            const Text('Create an Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 33,
                )),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.1,
                      right: 35,
                      left: 35),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      reusableTextField('First Name', Icons.person, false,
                          _firstNameTextController,
                          keyboardType: TextInputType.name,
                          paddingVertical:
                              MediaQuery.of(context).size.height * 0.015),
                      const SizedBox(
                        height: 20.0,
                      ),
                      reusableTextField('Last Name', Icons.person, false,
                          _lastNameTextController,
                          keyboardType: TextInputType.name,
                          paddingVertical:
                              MediaQuery.of(context).size.height * 0.015),
                      const SizedBox(
                        height: 20.0,
                      ),
                      reusableTextField('Enter Email', Icons.email, false,
                          _emailTextController,
                          keyboardType: TextInputType.emailAddress,
                          paddingVertical:
                              MediaQuery.of(context).size.height * 0.015),
                      const SizedBox(
                        height: 20.0,
                      ),
                      reusableTextField('Enter Password', Icons.lock_outline,
                          true, _passwordTextController,
                          keyboardType: TextInputType.visiblePassword,
                          paddingVertical:
                              MediaQuery.of(context).size.height * 0.015),
                      const SizedBox(
                        height: 20.0,
                      ),
                      reusableTextField('Re Enter Password', Icons.lock_outline,
                          true, _repasswordTextController,
                          keyboardType: TextInputType.visiblePassword,
                          paddingVertical:
                              MediaQuery.of(context).size.height * 0.015),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: reusableTextField(
                              'Street',
                              Icons.location_on,
                              false,
                              _streetTextController,
                              keyboardType: TextInputType.streetAddress,
                              paddingVertical:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: reusableTextField(
                              'Street 2',
                              Icons.location_on,
                              false,
                              _street2TextController,
                              keyboardType: TextInputType.streetAddress,
                              paddingVertical:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Expanded(
                            child: reusableTextField(
                              'City',
                              Icons.location_city,
                              false,
                              _cityTextController,
                              keyboardType: TextInputType.streetAddress,
                              paddingVertical:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: reusableTextField(
                              'Postal Code',
                              Icons.local_post_office,
                              false,
                              _postalCodeTextController,
                              keyboardType: TextInputType.number,
                              paddingVertical:
                                  MediaQuery.of(context).size.height * 0.015,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      reusableTextField(
                        'Mobile Number',
                        Icons.phone,
                        false,
                        _mobileNumberTextController,
                        keyboardType: TextInputType.phone,
                        paddingVertical:
                            MediaQuery.of(context).size.height * 0.015,
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.photo_library),
                            label: const Text('Select Image'),
                            onPressed: _getImage,
                          ),
                          _image != null
                              ? CircleAvatar(
                                  backgroundImage: FileImage(_image!),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      signInSignUpButton(context, false, () {
                        _registerUser();
                      },
                          paddingVertical:
                              MediaQuery.of(context).size.height * 0.015,
                          text: '')
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
