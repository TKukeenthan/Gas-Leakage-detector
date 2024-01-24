// ignore_for_file: camel_case_types, library_private_types_in_public_api, deprecated_member_use, prefer_const_constructors, annotate_overrides, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:gldapplication/provider/gas_leaky_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'widgets/show_alert.dart';

class leaky extends StatelessWidget {
  const leaky({super.key});

  Widget build(BuildContext context) {
    return Consumer<GasLeakProvider>(builder: (context, provider, _) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          padding: EdgeInsets.only(top: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'navbar');
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.purple),
                      child: Center(
                        child: Text(
                          'Refresh',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 157, 37, 161),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(55, 0, 0, 0),
                            blurRadius: 6,
                            spreadRadius: 4,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Gas value',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${provider.gasValue}',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.5,
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: SfRadialGauge(
                              axes: <RadialAxis>[
                                RadialAxis(
                                  minimum: 0,
                                  maximum: 1,
                                  axisLineStyle: AxisLineStyle(
                                    thickness: 0.1,
                                    cornerStyle: CornerStyle.bothCurve,
                                    color: provider.gasValue == 1
                                        ? Colors.red
                                        : Color.fromARGB(255, 255, 255, 255),
                                    thicknessUnit: GaugeSizeUnit.factor,
                                  ),
                                  ranges: <GaugeRange>[
                                    GaugeRange(
                                      startValue: 0,
                                      endValue: 1,
                                      color: provider.gasValue == 1
                                          ? Colors.red
                                          : Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ],
                                  pointers: <GaugePointer>[
                                    NeedlePointer(
                                      value: provider.gasValue,
                                      needleColor: provider.gasValue == 1
                                          ? Colors.red
                                          : Color.fromARGB(255, 255, 255, 255),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.015),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(55, 0, 0, 0),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Leak Status",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 157, 37, 161)),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.width * 0.35,
                            child: Container(
                              padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.03),
                              decoration: BoxDecoration(
                                color: provider.gasValue == 1
                                    ? Colors.red
                                    : Color.fromARGB(255, 157, 37, 161),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.safety_check,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width * 0.07,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          Text(
                            provider.gasValue == 1 ? 'Unsafe' : 'Safe',
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              color: provider.gasValue == 1
                                  ? Colors.red
                                  : Color.fromARGB(255, 157, 37, 161),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.003,
                          ),
                          TextButton(
                            onPressed: () {
                              helpCenter(context);
                            },
                            child: Text(
                              'Make a request for help',
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                                color: Color.fromARGB(255, 157, 37, 161),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SizedBox(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.05),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 22, 19, 19),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(0, 0, 0, 0),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Center(
                              child: Text(
                                'Time Elapsed',
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 157, 37, 161),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(
                                    "${provider.digitHours}:${provider.digitMinutes}:${provider.digitSeconds}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.1,
                                      color: Color.fromARGB(255, 157, 37, 161),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: RawMaterialButton(
                                  onPressed: () {
                                    (!provider.isTimerStarted)
                                        ? provider.start()
                                        : provider.stop();
                                  },
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: Color.fromARGB(255, 157, 37, 161),
                                    ),
                                  ),
                                  child: Text(
                                    (!provider.isTimerStarted)
                                        ? "Start"
                                        : "Pause",
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      color: Color.fromARGB(2255, 157, 37, 161),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.05,
                              ),
                              Expanded(
                                child: RawMaterialButton(
                                  onPressed: () {
                                    provider.reset();
                                  },
                                  shape: StadiumBorder(
                                    side: BorderSide(
                                      color: Color.fromARGB(255, 157, 37, 161),
                                    ),
                                  ),
                                  child: Text(
                                    "Reset",
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05,
                                      color: Color.fromARGB(255, 157, 37, 161),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ),
      );
    });
  }

  Future<dynamic> helpCenter(BuildContext context) {
    return showModalBottomSheet(
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

  void showGasLeakageAlert(BuildContext context) {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (context) {
          return GasLeakageAlert();
        },
      );
    });
  }
}
