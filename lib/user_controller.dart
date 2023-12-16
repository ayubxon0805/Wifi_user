// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_user/model.dart';
import 'package:wifi_user/user.dart';

class UserController extends GetxController {
  UserModel? userModel;
  String whoWinner = '';
  bool whodraw = false;
  List<String> logs = [];

  List<WifiModel> playLog = [];

  int port = 6060;
  Stream<NetworkAddress>? stream;
  NetworkAddress? address;
  @override
  void onInit() {
    getIpAddress();
    super.onInit();
  }

  getIpAddress() {
    stream = NetworkAnalyzer.discover2('192.168.0', port);

    stream!.listen(
      (NetworkAddress networkAddress) {
        if (networkAddress.exists && networkAddress.ip == '192.168.0.192') {
          address = networkAddress;
          userModel = UserModel(
            hostName: networkAddress.ip,
            port: port,
            onData: onData,
            onError: onError,
          );
        }
      },
    );

    update();
  }

  sendMessage(dynamic msg) {
    if (msg == 'boshlash') {
      logs.add(msg);
      userModel?.write(msg);
    } else if (msg == 'aniqlovchi') {
      userModel?.write(msg);
    } else {
      userModel?.write(msg);
    }
    update();
  }

  onData(dynamic data) async {
    final message = String.fromCharCodes(data);
    if (message == 'golib') {
      whoWinner = message;
    } else {
      playLog = (jsonDecode(message)["encodeData"])
          .map<WifiModel>((e) => WifiModel.fromJson(e))
          .toList();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('stopped', true);
      int durrang = 0;
      for (var drawitem in playLog) {
        if (drawitem.value != '') {
          durrang++;
        } else {}
      }
      if (durrang == 9) {
        whodraw = true;
      }
    }
    update();
  }

  onError(dynamic error) {
    debugPrint(" Error: $error");
  }
}
