import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class GasLeakageAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Container(
        height: 300,
        width: 300,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Icon(
              Icons.warning,
              size: 100,
              color: Colors.red,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Gas Leakage Alert',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'leaky');
                },
                child: Text('Go to Home Screen')),
            TextButton(
                onPressed: () {
                  helpCenter(context);
                },
                child: Text('Make Requst for help')),
            // TextButton(
            //     onPressed: () {
            //       Navigator.pushNamed(context, 'HomeScreen');
            //     },
            //     child: Text('Go to Chatcreen'))
          ],
        ),
      ),
    );
  }

  Future<dynamic> helpCenter(BuildContext context) {
    return showModalBottomSheet(
        barrierColor: Colors.black87,
        context: context,
        builder: (context) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        'Help Center',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Divider()
                    ],
                  ),
                ),
                _helpCenter(context, () {
                  UrlLauncher.launch("tel:0767625697");
                }, 'Fire service'),
                _helpCenter(context, () {}, 'Neighbour'),
                _helpCenter(context, () {}, 'Friend'),
                _helpCenter(context, () {}, 'Relative'),
              ],
            ),
          );
        });
  }

  Widget _helpCenter(BuildContext context, Function() onTap, String text) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.purple)),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
