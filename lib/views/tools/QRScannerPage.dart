import 'package:flutter/material.dart';
import 'package:images_picker/images_picker.dart';
import 'package:scan/scan.dart';

/// 扫码页面
class QRScannerPage extends StatefulWidget {
  final QRScannerPageConfig arguments;

  const QRScannerPage({required this.arguments});

  @override
  _QRScannerPageState createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  late StateSetter stateSetter;

  IconData lightIcon = Icons.flash_on;

  ScanController controller = ScanController();

  List<String> result = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('扫码'),
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    return Stack(children: [
      ScanView(
        controller: controller,
        scanAreaScale: widget.arguments.scanAreaSize,
        scanLineColor: widget.arguments.scanLineColor,
        onCapture: (String data) async {
          await showResult(content: '扫码结果\t$data');
          controller.resume();
        },
      ),
      Positioned(
        left: 50,
        bottom: 100,
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            stateSetter = setState;
            return MaterialButton(
                child: Icon(lightIcon, size: 30, color: Colors.greenAccent),
                onPressed: () {
                  controller.toggleTorchMode();
                  if (lightIcon == Icons.flash_on) {
                    lightIcon = Icons.flash_off;
                  } else {
                    lightIcon = Icons.flash_on;
                  }
                  stateSetter(() {});
                });
          },
        ),
      ),
      Positioned(
        right: 50,
        bottom: 100,
        child: MaterialButton(
            child: Icon(Icons.image,
                size: 30, color: Color.fromRGBO(4, 184, 67, 1)),
            onPressed: () async {
              await pickImage();
              // DialogUtil.showCommonDialog(context, '$result');
            }),
      ),
    ]);
  }

  Future<Future<Object?>> showResult({required String content}) async {
    return showGeneralDialog(
        context: context,
        pageBuilder: (context, anim1, anim2) {
          return new Text("1");
        },
        barrierColor: Colors.black.withOpacity(.6),
        barrierDismissible: true,
        barrierLabel: "",
        transitionDuration: Duration(milliseconds: 150),
        transitionBuilder: (context, anim1, anim2, child) {
          return Transform.scale(
              scale: anim1.value,
              child: Opacity(
                  opacity: anim1.value,
                  child: Center(
                    child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: new Material(
                          type: MaterialType.transparency,
                          child: new Container(
                              height: 450,
                              width: 300,
                              decoration: ShapeDecoration(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ))),
                              child: Column(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        content,
                                        style:
                                            TextStyle(height: 1, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                  DividerHorizontal(),
                                  Expanded(
                                    flex: 1,
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '确认',
                                              style: TextStyle(
                                                  color: Color(0xFFFF7B85),
                                                  fontSize: 18),
                                            ),
                                          ),
                                        ))
                                      ],
                                    ),
                                  )
                                ],
                              )),
                        )),
                  )));
        });
  }

  Future pickImage() async {
    List<Media>? files = await ImagesPicker.pick(
      pickType: PickType.image,
      count: 9,
    );
    if (files != null && files.isNotEmpty) {
      for (int i = 0; i < files.length; i++) {
        String? value = await Scan.parse(files[i].path);
        result.add(value!);
      }
      showResult(content: result.toString());
    }
  }
}

class QRScannerPageConfig {
  double scanAreaSize;
  Color scanLineColor;

  QRScannerPageConfig(
      {this.scanAreaSize: 1.0,
      this.scanLineColor: const Color.fromRGBO(4, 184, 67, 1)});
}

class DividerHorizontal extends StatelessWidget {
  final double height;
  final Color color;

  DividerHorizontal({this.height: 1, this.color: const Color(0xFFF8F9F8)});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      color: color,
    );
  }
}
