import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat_helper/main.dart';
import 'package:wechat_helper/views/service.dart';
import 'package:wechat_helper/views/tool.dart';

class HomePage extends StatefulWidget {
  final Map arguments;

  HomePage({Key? key, required this.arguments}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const methodChannel = MethodChannel('wechathelper');

  int _currentIndex = 0;

  Future<dynamic> _addNativeMethod(MethodCall methodCall) async {
    switch (methodCall.method) {
      case 'app1CountAdd':
        print("methodCall.arguments" + methodCall.arguments);
        setState(() {
          MyApp.appSetting.apk1Count += 1;
        });
        return true;
      case 'artworkCountAdd':
        print("methodCall.arguments" + methodCall.arguments);
        setState(() {
          MyApp.appSetting.artworkCount += 1;
        });
        return true;
      case 'cleanerCountAdd':
        print("methodCall.arguments" + methodCall.arguments);
        setState(() {
          MyApp.appSetting.cleanerCount += 1;
        });
        return true;
      case 'readerCountAdd':
        print("methodCall.arguments" + methodCall.arguments);
        setState(() {
          MyApp.appSetting.readerCount += 1;
        });
        return true;
    }
  }

  @override
  void initState() {
    methodChannel.setMethodCallHandler(_addNativeMethod);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: ValueNotifier(MyApp.appSetting.inited),
      builder: (BuildContext context, value, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("我信助手"),
          ),
          body: [ToolPage(), ServicePage()][_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            selectedIconTheme: IconThemeData(size: 32),
            selectedFontSize: 18,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.space_dashboard), label: "Tool"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.accessibility_new), label: "Service")
            ],
          ), // TSheethis trailing comma makes auto-formatting nicer for build methods.
        );
      },
    );
  }
}
