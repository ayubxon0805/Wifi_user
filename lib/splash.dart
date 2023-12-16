import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_user/game_page.dart';
import 'package:wifi_user/model.dart';
import 'package:wifi_user/user_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserController controller = Get.put(UserController());

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 28, 55, 233),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 55,
            top: 150,
          ),
          child: SizedBox(
            width: 300,
            height: 300,
            child: Image.asset(
              'images/tictac.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Do you want to play a new game',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      controller.playLog = a;
                      final SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setBool("stopped", true);
                      controller.sendMessage("boshlash");
                      setState(() {});
                      // ignore: use_build_context_synchronously
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return const GamePage();
                        },
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(220, 50),
                        backgroundColor: Colors.blue),
                    child: const Icon(
                      Icons.play_circle_fill_outlined,
                      color: Colors.white,
                      size: 50,
                    )),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
