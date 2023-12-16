// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timer_widget/flutter_timer_widget.dart';
import 'package:flutter_timer_widget/timer_controller.dart';
import 'package:flutter_timer_widget/timer_style.dart';
import 'package:get/get.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_user/bloc/set_dialog_bloc.dart';
import 'package:wifi_user/model.dart';
import 'package:wifi_user/splash.dart';
import 'package:wifi_user/user_controller.dart';

class GamePage extends StatefulWidget {
  const GamePage({
    super.key,
  });
  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  // ignore: prefer_typing_uninitialized_variables
  UserController controllera = Get.put(UserController());
  // ignore: prefer_typing_uninitialized_variables
  int drawCounter = 0;
  List<String> winner = ['', '', ''];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (controller) {
        return BlocConsumer<SetDialogBloc, SetDialogState>(
          listener: (context, state) {
            if (state is SetSuccesState) {
              if (controller.whoWinner == 'golib') {
                BlocProvider.of<SetDialogBloc>(context)
                    .add(SetStartDiffalogEvent());
              }
            }
          },
          builder: (context, state) {
            if (controller.whoWinner == 'golib') {
              BlocProvider.of<SetDialogBloc>(context)
                  .add(SetStartDialogEvent());
            }
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.blue,
                centerTitle: true,
                title: const Text(
                  'Tic-Tac-Toe',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.white),
                ),
              ),
              body: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    controller.whoWinner == 'golib' ? 'winner Player o ' : '',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    winner.first == 'x' ? 'winner Player: x' : '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  controller.whoWinner == 'golib' ? aaa() : const Text(''),
                  controller.whodraw == true ? bbbd() : const Text(''),
                  Padding(
                      padding:
                          const EdgeInsets.only(left: 40, right: 40, top: 130),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.43,
                        width: MediaQuery.of(context).size.width * 1,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 3,
                                  mainAxisSpacing: 3),
                          scrollDirection: Axis.vertical,
                          itemCount: controller.playLog.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black)),
                              width: 90,
                              height: 90,
                              child: FittedBox(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    if (prefs.getBool('stopped') == true) {
                                      if (controller.playLog[index].value !=
                                              'o' &&
                                          controller.playLog[index].value ==
                                              '') {
                                        WifiModel statx =
                                            WifiModel(index: index, value: 'x');
                                        controller.playLog.insert(index, statx);
                                        controller.playLog.remove(
                                            controller.playLog[index + 1]);

                                        var a = jsonEncode(
                                            {'encodeData': controller.playLog});

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

                                          if (first == second &&
                                              second == third &&
                                              first != '') {
                                            winner = line;

                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.success,
                                              animType: AnimType.topSlide,
                                              showCloseIcon: true,
                                              title: 'Nobody won',
                                              desc:
                                                  'Do you want to play again?',
                                              btnCancelOnPress: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                  builder: (context) {
                                                    return const SplashScreen();
                                                  },
                                                ));
                                                setState(() {});
                                              },
                                              btnOkOnPress: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                  builder: (context) {
                                                    return const SplashScreen();
                                                  },
                                                ));
                                              },
                                            ).show();
                                          }
                                        }

                                        int drawCounter = 0;

                                        for (var drawItem
                                            in controller.playLog) {
                                          if (drawItem.value != "") {
                                            drawCounter = drawCounter + 1;
                                          }
                                          if (drawCounter == 9 &&
                                              winner.first != 'x') {
                                            AwesomeDialog(
                                              context: context,
                                              dialogType: DialogType.info,
                                              animType: AnimType.topSlide,
                                              showCloseIcon: true,
                                              title: 'Nobody won',
                                              desc:
                                                  'Do you want to play again?',
                                              btnOkOnPress: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                  builder: (context) {
                                                    return const SplashScreen();
                                                  },
                                                ));
                                              },
                                            ).show();
                                            //    controller.sendMessage('draw');
                                          } else {}
                                        }

                                        if (winner.first == 'x') {
                                          controller.sendMessage(a);

                                          controller.sendMessage('aniqlovchi');

                                          // ignore: avoid_printx
                                        } else {
                                          controller.sendMessage(a);
                                        }

                                        await prefs.setBool("stopped", false);
                                      }
                                    }
                                    controller.update();
                                    controllera.update();
                                    setState(() {});
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0)),
                                      minimumSize: const Size(100, 100)),
                                  child: Text(
                                    controller.playLog[index].value,
                                    style: TextStyle(
                                        fontSize: 60,
                                        color:
                                            controller.playLog[index].value ==
                                                    'x'
                                                ? Colors.red
                                                : Colors.green),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  //////////////////////

  aaa() {
    // ignore: sized_box_for_whitespace
    return Container(
      height: 1,
      width: 30,
      child: FlutterTimer(
        duration: Duration.zero,
        onFinished: () {
          return AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  animType: AnimType.topSlide,
                  showCloseIcon: true,
                  title: 'You Failed',
                  desc: 'Do you want to play again?',
                  btnOkOnPress: () {
                    controllera.whoWinner = '';
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const SplashScreen();
                      },
                    ));
                  },
                  btnOkIcon: Icons.cancel,
                  btnOkColor: Colors.red)
              .show();
        },
        timerController: TimerController(
          elevation: 0,
          margin: const EdgeInsets.all(69.0),
          padding: const EdgeInsets.all(50.0),
          background: Colors.red,
          timerStyle: TimerStyle.circular,
          timerTextStyle: const TextStyle(color: Colors.white, fontSize: 30),
          subTitleTextStyle: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }

  bbbd() {
    return Container(
      height: 30,
      width: 10,
      child: FlutterTimer(
        duration: Duration.zero,
        onFinished: () {
          return AwesomeDialog(
            context: context,
            barrierColor: Colors.red,
            dialogType: DialogType.info,
            animType: AnimType.topSlide,
            showCloseIcon: true,
            title: 'Nobody won',
            desc: 'Do you want to play again?',
            btnOkOnPress: () {
              controllera.whodraw = false;
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return const SplashScreen();
                },
              ));
            },
          ).show();
        },
        timerController: TimerController(
          elevation: 0,
          margin: const EdgeInsets.all(4.0),
          padding: const EdgeInsets.all(0.0),
          background: Colors.red,
          timerStyle: TimerStyle.rectangular,
          timerTextStyle: const TextStyle(color: Colors.white, fontSize: 30),
          subTitleTextStyle: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}
