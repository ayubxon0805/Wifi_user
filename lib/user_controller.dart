// ignore_for_file: avoid_print
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wifi_user/model.dart';
import 'package:wifi_user/user.dart';

class UserController extends GetxController {
  UserModel? userModel;
  List<String> logs = [];
  List<WifiModel> playLog = [
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
  int port = 4040;
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
        print('++++++++++++====');

        if (networkAddress.exists && networkAddress.ip == '192.168.0.192') {
          print('++++++++++++');
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
    print('playlog hozir = $playLog');
    if (msg == 'boshlash') {
      logs.add(msg);
      userModel?.write(msg);
    } else {
      userModel?.write(msg);
      logs.add(msg);
    }

    update();
  }

  onData(dynamic data) async {
    final message = String.fromCharCodes(data);

    print('message ===============$message');

    playLog = (jsonDecode(message)["encodeData"])
        .map<WifiModel>((e) => WifiModel.fromJson(e))
        .toList();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('stopped', true);

    update();
  }

  onError(dynamic error) {
    debugPrint(" Error: $error");
  }
}
