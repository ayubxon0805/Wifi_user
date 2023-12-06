// ignore_for_file: unnecessary_null_comparison, prefer_const_constructors, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_user/model.dart';
import 'package:wifi_user/user_controller.dart';

class GamePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables

  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  UserController controllerX = Get.put(UserController());
  var winner;
  List<WifiModel> alog = [];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            centerTitle: true,
            title: const Text(
              'Tic-Tac-Toe',
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
            ),
          ),
          body: Column(
            children: [
              SizedBox(height: 10),
              Text(
                winner?.first == 'o' || winner?.first == 'x'
                    ? 'winner: Player ${winner.first}'
                    : '',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40, top: 200),
                  // ignore: sized_box_for_whitespace
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.43,
                    width: MediaQuery.of(context).size.width * 1,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, mainAxisSpacing: 3),
                      scrollDirection: Axis.vertical,
                      itemCount: controllerX.playLog.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          width: 90,
                          height: 90,
                          child: FittedBox(
                            child: FloatingActionButton(
                              heroTag: Text('ardamir'),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0)),
                              onPressed: () async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                if (prefs.getBool('stopped') == true) {
                                  if (controllerX.playLog[index].value != 'o') {
                                    WifiModel statx =
                                        WifiModel(index: index, value: 'x');
                                    controllerX.playLog.insert(index, statx);
                                    controllerX.playLog
                                        .remove(controllerX.playLog[index + 1]);

                                    // controllerX.playLog = controllerX.playLog;
                                    var a = jsonEncode(
                                        {'encodeData': controllerX.playLog});

                                    var lines = [
                                      [
                                        (controller.playLog[0].value),
                                        (controller.playLog[1].value),
                                        (controller.playLog[2].value)
                                      ],
                                      [
                                        (controller.playLog[3].value),
                                        (controller.playLog[4].value),
                                        (controller.playLog[5].value)
                                      ],
                                      [
                                        (controller.playLog[6].value),
                                        (controller.playLog[7].value),
                                        (controller.playLog[8].value)
                                      ],
                                      [
                                        (controller.playLog[0].value),
                                        (controller.playLog[3].value),
                                        (controller.playLog[6].value)
                                      ],
                                      [
                                        (controller.playLog[1].value),
                                        (controller.playLog[4].value),
                                        (controller.playLog[7].value)
                                      ],
                                      [
                                        (controller.playLog[2].value),
                                        (controller.playLog[5].value),
                                        (controller.playLog[8].value)
                                      ],
                                      [
                                        (controller.playLog[0].value),
                                        (controller.playLog[4].value),
                                        (controller.playLog[8].value)
                                      ],
                                      [
                                        (controller.playLog[2].value),
                                        (controller.playLog[4].value),
                                        (controller.playLog[6].value)
                                      ],
                                    ];
                                    for (var line in lines) {
                                      var first = line[0];
                                      var second = line[1];
                                      var third = line[2];
                                      // ignore: avoid_print
                                      print('line teng $line ga');
                                      if (first == second &&
                                          second == third &&
                                          first != '') {
                                        winner = line;

                                        break;
                                      }
                                    }
                                    controllerX.sendMessage(a);
                                    await prefs.setBool("stopped", false);
                                    setState(() {});

                                    controllerX.update();
                                  }
                                }
                              },
                              child: Text(
                                controllerX.playLog[index].value,
                                style: TextStyle(
                                    fontSize: 33,
                                    color:
                                        controllerX.playLog[index].value == 'x'
                                            ? Colors.red
                                            : Colors.green),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )),
              ElevatedButton(
                  onPressed: () {
                    controllerX.playLog = alog = [
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
                    controllerX.update();
                  },
                  child: Text('clear'))
            ],
          ),
        );
      },
    );
  }
}
