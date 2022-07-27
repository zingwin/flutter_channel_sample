import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_channel_sample/flutter_channel_sample.dart';
import 'dart:math' show Random;
import 'package:flutter_channel_sample/gen/protos/data_channel.pb.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/scheduler.dart';
import 'package:fps_monitor/widget/custom_widget_inspector.dart';

void main() {
  runApp(const MyApp());
}

String gJsonEncode(dynamic obj) {
  final jsonStr = jsonEncode(obj);
  return jsonStr;
}

getMsg(sendPort) async {
  final rep = await FlutterChannelSample.filePassData("xxxxxxxxxxx");
  // sendPort.send("hello");
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<NavigatorState> globalKey = GlobalKey();
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();

    // WidgetsBinding.instance?.addPostFrameCallback((t) {
    //   if ((globalKey.currentState?.overlay ?? null) != null) {
    //     overlayState = globalKey.currentState!.overlay!;
    //   }
    // });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await FlutterChannelSample.platformVersion ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  String generateRandomString(int length) {
    final _random = Random();
    const _availableChars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final randomString = List.generate(length,
            (index) => _availableChars[_random.nextInt(_availableChars.length)])
        .join();
    return randomString;
  }

  final List<String> tmpList = [];
  void _genFlakerData(int count) {
    tmpList.clear();
    for (int i = 0; i < count; i++) {
      tmpList.add(generateRandomString(150));
    }
    debugPrint("done!");
  }

  void _passDataUseChannel() async {
    final s = DateTime.now();
    final rep = await FlutterChannelSample.batchStringToNavtive(tmpList);
    print('使用时长： ${DateTime.now().difference(s).inMilliseconds} 毫秒');
    print("返回结果: $rep");
  }

  DataChannel? bufDataChannel;
  void _jsonToBuf() {
    if (tmpList.isEmpty) {
      return;
    }
    final Map tmpMap = {};
    tmpMap['1'] = "leaf";
    tmpMap['2'] = tmpList;
    final s = DateTime.now();
    bufDataChannel = DataChannel.fromJson(jsonEncode(tmpMap));
    print('_jsonToBuf： ${DateTime.now().difference(s).inMilliseconds} 毫秒');
  }

  void _passPBUseChannel() async {
    if (bufDataChannel == null) return;

    final s = DateTime.now();
    final rep = await FlutterChannelSample.batchProtoBufToNavtive(
        bufDataChannel!.writeToBuffer());
    print('使用时长： ${DateTime.now().difference(s).inMilliseconds} 毫秒');
    print("返回结果: $rep");
  }

  Isolate? isolate;
  void _filePassData() async {
    final s = DateTime.now();
    final doc = (await getApplicationDocumentsDirectory()).path;
    final path = "$doc/test.dat";
    File f = File(path);
    // final data = json.encode(tmpList);
    final data = await compute(gJsonEncode, tmpList);
    f.writeAsStringSync(data);

    final rep = await FlutterChannelSample.filePassData(path);

    print('使用时长： ${DateTime.now().difference(s).inMilliseconds} 毫秒');
    print("返回结果: $rep");

    //
    // ReceivePort receivePort = ReceivePort();
    // //创建子Isolate对象
    // isolate = await Isolate.spawn(getMsg, receivePort.sendPort);
    // //监听子Isolate的返回数据
    // receivePort.listen((data) {
    //   print('data：$data');
    //   receivePort.close();
    //   //关闭Isolate对象
    //   isolate?.kill(priority: Isolate.immediate);
    //   isolate = null;
    // });
  }

  void _binaryPassData() async {
    final s = DateTime.now();

    final rep = await FlutterChannelSample.sendBinaryData(bufDataChannel!);

    print('使用时长： ${DateTime.now().difference(s).inMilliseconds} 毫秒');
    print("返回结果: $rep");
  }

  void _jsonPassData() async {
    final xx = FlutterChannelSample.nativeAdd(3, 5);
    print("fii add :$xx");

    final s = DateTime.now();

    final rep = await FlutterChannelSample.sendJsonData(tmpList);

    print('使用时长： ${DateTime.now().difference(s).inMilliseconds} 毫秒');
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((t) {
      overlayState = globalKey.currentState!.overlay!;
    });
    return MaterialApp(
      navigatorKey: globalKey,
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Running on: $_platformVersion\n'),
              Row(
                children: const [
                  CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.red), // 进度条当前进度颜色
                  ),
                  SizedBox(width: 10),
                  CircularProgressIndicator(
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.lightGreen), // 进度条当前进度颜色
                  ),
                ],
              ),
              Wrap(
                spacing: 10,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        _genFlakerData(100000);
                      },
                      child: const Text("生成100000条字符串")),
                  ElevatedButton(
                      onPressed: () {
                        _genFlakerData(500000);
                      },
                      child: const Text("生成500000条字符串")),
                  ElevatedButton(
                      onPressed: () {
                        _genFlakerData(1000000);
                      },
                      child: const Text("生成1000000条字符串")),
                ],
              ),
              const Divider(),
              ElevatedButton(
                  onPressed: _passDataUseChannel,
                  child: const Text("Flutter Channel传递数据Map")),
              const Divider(),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: _jsonToBuf,
                      child: const Text("json->protoBuf")),
                  ElevatedButton(
                      onPressed: () {
                        _passPBUseChannel();
                      },
                      child: const Text("Flutter Channel传递数据Buf")),
                ],
              ),
              const Divider(),
              const Text("写文件传递"),
              ElevatedButton(
                  onPressed: _filePassData, child: const Text("file Pass")),
              const Divider(),
              ElevatedButton(
                  onPressed: _binaryPassData,
                  child: const Text("BasicMessageChannel buf")),
              const Divider(),
              ElevatedButton(
                  onPressed: _jsonPassData,
                  child: const Text("BasicMessageChannel json")),
            ],
          )),
      builder: (ctx, child) => CustomWidgetInspector(
        child: child!,
      ),
    );
  }
}
