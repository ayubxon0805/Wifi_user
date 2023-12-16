import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_user/game_page.dart';
import 'package:wifi_user/model.dart';
import 'package:wifi_user/user_controller.dart';

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
  List<WifiModel> a = [
    WifiModel(index: 1, value: ''),
    WifiModel(index: 2, value: ''),
    WifiModel(index: 3, value: ''),
    WifiModel(index: 4, value: ''),
    WifiModel(index: 5, value: ''),
    WifiModel(index: 6, value: ''),
    WifiModel(index: 7, value: ''),
    WifiModel(index: 8, value: ''),
    WifiModel(index: 9, value: ''),
  ];
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
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (controller.stream != null) {
                                controller.getIpAddress();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(200, 40)),
                            child: const Text('Search'),
                          ),
                          const SizedBox(height: 10),
                          controller.address == null
                              ? const Text('')
                              : Column(
                                  children: [
                                    const Text('Wifi connect to user'),
                                    Text(controller.address!.ip),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                  controller.userModel == null
                      ? const Text("No Server Found")
                      : Text(''),
                  SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: () async {
                        controller.playLog = a;
                        final SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool("stopped", true);
                        controller.sendMessage("boshlash");
                        // ignore: use_build_context_synchronously
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return const GamePage();
                          },
                        ));
                      },
                      style:
                          ElevatedButton.styleFrom(minimumSize: Size(200, 40)),
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
