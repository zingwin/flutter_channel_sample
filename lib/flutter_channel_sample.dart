import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_channel_sample/gen/protos/data_channel.pb.dart';
import 'package:flutter_channel_sample/leaf_test_codec.dart';
import 'dart:ffi';
import 'dart:io';

class FlutterChannelSample {
  static DynamicLibrary nativeAddLib = Platform.isAndroid
      ? DynamicLibrary.open('libnative_add.so')
      : DynamicLibrary.executable();

  static int Function(int x, int y) nativeAdd = nativeAddLib
      .lookup<NativeFunction<Int32 Function(Int32, Int32)>>('native_add')
      .asFunction();

  static const MethodChannel _channel = MethodChannel('flutter_channel_sample');

  static const BasicMessageChannel _basicChannel =
      BasicMessageChannel<DataChannel>(
          "flutter_channel_sample.data", LeafTestCodec());

  static const BasicMessageChannel _jsonChannel = BasicMessageChannel<dynamic>(
      "flutter_channel_sample.json", JSONMessageCodec());

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String?> batchStringToNavtive(List<String> strList) async {
    try {
      final String? rep = await _channel.invokeMethod(
          "batchStringToNavtive", {"path": "path", "batchStringList": strList});
      return rep;
    } catch (e) {
      debugPrint("batchStringFoNavtive, $e");
      rethrow;
    }
  }

  static Future<String?> batchProtoBufToNavtive(Uint8List bufData) async {
    try {
      final String? rep = await _channel
          .invokeMethod("batchProtoBufToNavtive", {'data': bufData});
      return rep;
    } catch (e) {
      debugPrint("batchStringFoNavtive, $e");
      rethrow;
    }
  }

  static Future<String?> filePassData(String filePath) async {
    try {
      final String? rep =
          await _channel.invokeMethod("filePassData", {'filePath': filePath});
      return rep;
    } catch (e) {
      debugPrint("batchStringFoNavtive, $e");
      rethrow;
    }
  }

  static Future<DataChannel?> sendBinaryData(DataChannel byteData) async {
    try {
      final DataChannel? rep = await _basicChannel.send(byteData);
      return rep;
    } catch (e) {
      debugPrint("batchStringFoNavtive, $e");
      rethrow;
    }
  }

  static Future<DataChannel?> sendJsonData(dynamic byteData) async {
    try {
      final DataChannel? rep = await _jsonChannel.send(byteData);
      return rep;
    } catch (e) {
      debugPrint("batchStringFoNavtive, $e");
      rethrow;
    }
  }
}
