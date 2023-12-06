import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';

typedef Uint8ListCallback = Function(Uint8List data);
typedef DynamicCallback = Function(Uint8List data);
DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

class UserModel {
  String hostName;
  int port;
  Uint8ListCallback onData;
  DynamicCallback onError;
  UserModel({
    required this.hostName,
    required this.port,
    required this.onData,
    required this.onError,
  });

  bool isConnnected = false;
  Socket? socket;

  Future<void> connect() async {
    try {
      socket = await Socket.connect(hostName, port);
      socket!.listen(onData, onError: onError, onDone: () async {
        final info = await deviceInfo.androidInfo;
        disConnect(info);
        isConnnected = false;
      });
      isConnnected = true;
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void write(dynamic message) {
    // ignore: avoid_print
    socket?.write(message);
  }

  Future<void> disConnect(AndroidDeviceInfo androidDeviceInfo) async {
    if (socket != null) {
      socket!.destroy();
    }
    isConnnected = false;
  }
}
