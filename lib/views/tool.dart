import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:wechat_helper/views/tools/QRScannerPage.dart';

class ToolPage extends StatefulWidget {
  const ToolPage({Key? key, arguments}) : super(key: key);

  @override
  _ToolPageState createState() => _ToolPageState();
}

class _ToolPageState extends State<ToolPage> {
  static const methodChannel = const MethodChannel('wechathelper');

  //方法通道的方法是异步的
  Future<bool> invokeAndroidBoolMethod(String methodName) async {
    bool result = await methodChannel.invokeMethod(methodName);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            maxCrossAxisExtent: 200.0,
            childAspectRatio: 0.8 //宽高比为2
            ),
        children: <Widget>[
          // Text("吾爱破解论坛专用版本")
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white)),
            onPressed: () {
              Navigator.pushNamed(context, "/tool/qr",
                  arguments: QRScannerPageConfig());
              // Navigator.pushNamed(context, "/tool/qrpro",arguments: Key("value"));
            },
            child: Column(
              children: [
                //https://github.com/DeveloperLibs/flutter_qr_barcode
                //https://blog.csdn.net/qq_39694327/article/details/115695661
                //https://blog.csdn.net/qq_39694327/article/details/115690769
                QrImage(
                  data: "我信助手",
                  version: QrVersions.auto,
                  size: 150.0,
                ),
                // Image.asset("assets/images/service/qq.jpg", fit: BoxFit.cover),
                Text(
                  "二维码",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                )
              ],
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white)),
            onPressed: () {
              // Navigator.pushNamed(context, "/tool/qr",arguments: QRScannerPageConfig());
              Navigator.pushNamed(context, "/tool/qrpro",
                  arguments: Key("value"));
            },
            child: Column(
              children: [
                //https://github.com/DeveloperLibs/flutter_qr_barcode
                //https://blog.csdn.net/qq_39694327/article/details/115695661
                //https://blog.csdn.net/qq_39694327/article/details/115690769
                QrImage(
                  data: "我信助手",
                  version: QrVersions.auto,
                  size: 150.0,
                ),
                // Image.asset("assets/images/service/qq.jpg", fit: BoxFit.cover),
                Text(
                  "二维码",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                )
              ],
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white)),
            onPressed: () {
              invokeAndroidBoolMethod("joinQQGroup");
            },
            child: Column(
              children: [
                Image.asset("assets/images/service/qq.jpg", fit: BoxFit.cover),
                Text(
                  "反馈意见",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
