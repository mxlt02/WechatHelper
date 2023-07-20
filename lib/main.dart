import 'package:flutter/material.dart';
import 'package:wechat_helper/views/index.dart';
import 'package:wechat_helper/views/service.dart';
import 'package:wechat_helper/views/tool.dart';
import 'package:wechat_helper/views/tools/QRBarcodeScreen.dart';
import 'package:wechat_helper/views/tools/QRScannerPage.dart';

import 'entity/AppSetting.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static AppSetting appSetting = AppSetting();

  final Map<String, Function> routes = {
    "/": (context, {arguments}) => HomePage(arguments: arguments ?? {}),
    "/tool": (context, {arguments}) => ToolPage(arguments: arguments ?? {}),
    "/tool/qr": (context, {arguments}) =>
        QRScannerPage(arguments: arguments ?? {}),
    "/tool/qrpro": (context, {arguments}) =>
        QRBarcodeScreen(arguments: arguments ?? {}),
    "/service": (context, {arguments}) =>
        ServicePage(arguments: arguments ?? {}),
  };

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '我信助手',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: HomePage(arguments: {"title":'我信助手 Version:0.0.1'}),
      initialRoute: "/",
      onGenerateRoute: (RouteSettings settings) {
// 统一处理
        final String? name = settings.name;
        final Function? pageContentBuilder = this.routes[name];
        if (pageContentBuilder != null) {
          if (settings.arguments != null) {
            final Route route = MaterialPageRoute(
                builder: (context) =>
                    pageContentBuilder(context, arguments: settings.arguments));
            return route;
          } else {
            final Route route = MaterialPageRoute(
                builder: (context) => pageContentBuilder(context));
            return route;
          }
        }
      },
    );
  }
}
