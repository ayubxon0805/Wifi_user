// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_user/game_page.dart';
import 'package:wifi_user/user_controller.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MobileApp(),
    );
  }
}

class MobileApp extends StatefulWidget {
  const MobileApp({
    super.key,
  });
  @override
  State<MobileApp> createState() => _MobileAppState();
}

class _MobileAppState extends State<MobileApp> {
  TextEditingController con = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      init: UserController(),
      builder: (controller) {
        return Scaffold(
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Column(
                children: [
                  SizedBox(height: 50),
                  InkWell(
                    onTap: () async {
                      if (controller.userModel != null) {
                        await controller.userModel!.connect();
                      } else {
                        // ignore: avoid_print
                        print('null ga teng boldi');
                      }
                      // final info = await deviceInfo.androidInfo;
                    },
                    child: Column(
                      children: [
                        controller.address == null
                            ? const Text('Not Found')
                            : Column(
                                children: [
                                  const Text('Wifi connect to user'),
                                  Text(controller.address!.ip),
                                ],
                              ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              controller.getIpAddress();
                              setState(() {});
                            },
                            child: const Text('Search'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  controller.userModel == null
                      ? const Text("No Server Found")
                      : Text(''),
                  ElevatedButton(
                      onPressed: () async {
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool("stopped", true);
                        controller.sendMessage("boshlash");
                        // ignore: use_build_context_synchronously
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return GamePage();
                          },
                        ));
                      },
                      child: const Text("Send"))
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
