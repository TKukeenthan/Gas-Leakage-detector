// ignore_for_file: deprecated_member_use, body_might_complete_normally_catch_error

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../chatUser.dart';

class ProfileMenu extends StatefulWidget {
  const ProfileMenu({Key? key}) : super(key: key);

  @override
  State<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends State<ProfileMenu> {
  late ChatUser user;
  bool _isEditing = false;

  final _formKey = GlobalKey<FormState>();
  final _addressStreetController = TextEditingController();
  final _addressStreet2Controller = TextEditingController();
  final _addressCityController = TextEditingController();
  final _addressPostalCodeController = TextEditingController();
  final _aboutController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _firstNameTextController = TextEditingController();

  get image => null;

  @override
  void initState() {
    super.initState();
    user = ChatUser(
        about: '',
        address: {},
        createdAt: '',
        email: '',
        id: '',
        image: '',
        isOnline: true,
        lastActive: '',
        mobile_number: '',
        name: '',
        pushToken: '',
        home_location: {});
    getUserData();
  }

  void getUserData() async {
    User? firebaseUser = FirebaseAuth.instance.currentUser;
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser!.uid)
        .get();
    user = ChatUser.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    _addressStreetController.text = user.address['street'] ?? '';
    _addressStreet2Controller.text = user.address['street2'] ?? '';
    _addressCityController.text = user.address['city'] ?? '';
    _addressPostalCodeController.text = user.address['postalCode'] ?? '';
    _aboutController.text = user.about ?? '';
    _mobileNumberController.text = user.mobile_number;
    _firstNameTextController.text = user.name;
    setState(() {});
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      User? firebaseUser = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser!.uid)
          .update({
        'name': _firstNameTextController.text,
        'address': {
          'street': _addressStreetController.text,
          'street2': _addressStreet2Controller.text,
          'city': _addressCityController.text,
          'postalCode': _addressPostalCodeController.text,
        },
        'about': _aboutController.text,
        'mobile_number': _mobileNumberController.text,
      });
      setState(() {
        _isEditing = false;
        user.address = {
          'street': _addressStreetController.text,
          'street2': _addressStreet2Controller.text,
          'city': _addressCityController.text,
          'postalCode': _addressPostalCodeController.text,
        };
        user.about = _aboutController.text;
        user.mobile_number = _mobileNumberController.text;
        user.name = _firstNameTextController.text;
      });
    }
  }

  void _updateProfilePicture() async {
    // Show a dialog box where the user can select a new profile picture.
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Upload the new profile picture to Firebase Storage.
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('users/${user.id}/profile_picture.jpg');
      UploadTask uploadTask =
          storageReference.putFile(image.path(pickedFile.path));
      await uploadTask.whenComplete(() {});

      // Get the new profile picture URL and update the user object.
      String downloadURL =
          await storageReference.getDownloadURL().catchError((onError) {
        if (kDebugMode) {
          print(onError);
        }
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .update({'image': downloadURL});
      setState(() {
        user.image = downloadURL;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 36, 37, 37),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 36, 37, 37),
        title: const Text(
          'Profile Menu',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            FirebaseAuth.instance.signOut().then((value) {
              Navigator.pushReplacementNamed(context, 'splashScreen');
            });
          },
          icon: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
        ),
      ),
      body: user.id.isNotEmpty
          ? SingleChildScrollView(
              child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20.0),
                    GestureDetector(
                      onTap: _updateProfilePicture,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.image),
                        radius: 50.0,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Card(
                      color: const Color.fromARGB(255, 36, 37, 37),
                      child: ListTile(
                        title: const Text(
                          'Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: _isEditing
                            ? TextFormField(
                                controller: _firstNameTextController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Enter your name',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : Text(
                                user.name,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                    Card(
                      color: const Color.fromARGB(255, 36, 37, 37),
                      child: ListTile(
                        title: const Text(
                          'About',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: _isEditing
                            ? TextFormField(
                                controller: _aboutController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Enter your about',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : Text(
                                user.about,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Card(
                      color: const Color.fromARGB(255, 36, 37, 37),
                      child: ListTile(
                        title: const Text(
                          'Mobile Number',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: _isEditing
                            ? TextFormField(
                                controller: _mobileNumberController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Enter your mobile number',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : Text(
                                user.mobile_number,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Card(
                      color: const Color.fromARGB(255, 36, 37, 37),
                      child: ListTile(
                        title: const Text(
                          'Address',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: _isEditing
                            ? Column(
                                children: [
                                  TextFormField(
                                    controller: _addressStreetController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Enter your street address',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _addressStreet2Controller,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText:
                                          'Enter your apartment, suite, etc. (optional)',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _addressCityController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Enter your city',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _addressPostalCodeController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Enter your postal code',
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : user.address.isEmpty
                                ? Container()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.address['street'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        user.address['street2'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        user.address['city'] ??
                                            '' +
                                                ' - ' +
                                                user.address['postalCode'] ??
                                            '',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    _isEditing
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: _saveChanges,
                                child: const Text('Save'),
                              ),
                              ElevatedButton(
                                onPressed: _toggleEdit,
                                child: const Text('Cancel'),
                              ),
                            ],
                          )
                        : ElevatedButton(
                            onPressed: _toggleEdit,
                            child: const Text('Edit'),
                          ),
                  ],
                ),
              ),
            ))
          : const Center(
              child: CircularProgressIndicator(),
            ),

      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
