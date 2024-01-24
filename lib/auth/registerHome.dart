// ignore_for_file: file_names

import 'package:flutter/material.dart';

class RegisterHomeLocation extends StatefulWidget {
  const RegisterHomeLocation({Key? key}) : super(key: key);

  @override
  _RegisterHomeLocationState createState() => _RegisterHomeLocationState();
}

class _RegisterHomeLocationState extends State<RegisterHomeLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Location'),
        leading: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, 'navbar');
          },
          child: const Text('Skip'),
        ),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Add Location'),
          onPressed: () {
            Navigator.pushNamed(context, 'MapScreen');
          },
        ),
      ),
    );
  }
}
