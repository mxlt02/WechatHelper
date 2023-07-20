import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat_helper/entity/AppSetting.dart';
import 'package:wechat_helper/main.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({Key? key, arguments}) : super(key: key);

  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> with WidgetsBindingObserver {
  // static const platform = const MethodChannel("mxlt.flutter.dev/file");
  // String openFileUrl = '';
  static final AppSetting appSetting = MyApp.appSetting;
  static const methodChannel = MethodChannel('wechathelper');

  // static bool accessibilityEnable = false;

  @override
  void initState() {
    super.initState();
    // checkAccessibility();
    // Listen to lifecycle events.
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  // void checkAccessibility() async {
  //   accessibilityEnable =
  //   await invokeAndroidBoolMethod("checkAccessibility");
  // }

  //  生命周期变化时回调
  //  resumed:应用可见并可响应用户操作
  //  inactive:用户可见，但不可响应用户操作
  //  paused:已经暂停了，用户不可见、不可操作
  //  suspending：应用被挂起，此状态IOS永远不会回调
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // setState(() {
    //
    // });
    if (state == AppLifecycleState.resumed) {
      setState(() {
        asyncFun() async {
          // appSetting.init();
          appSetting.accessibilityEnable =
              await methodChannel.invokeMethod('checkAccessibility');
          appSetting.isIgnoringBatteryOptimizations =
              await invokeAndroidBoolMethod("checkBatteryOptimizations");
          setState(() {});
        }

        asyncFun();
      });
    }
    print("didChangeAppLifecycleState: $state");
    print(
        "didChangeAppLifecycleState-accessibilityEnable: $appSetting.accessibilityEnable");
  }

  //方法通道的方法是异步的
  Future<bool> invokeAndroidBoolMethod(String methodName) async {
    bool result = await methodChannel.invokeMethod(methodName);
    return result;
  }

  Widget widgetEnable(
      {required Widget widget, required bool enable, String tip = ''}) {
    if (enable) {
      return widget;
    } else {
      return Stack(
        alignment: Alignment(-0.8, -0.9),
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              // 设置混合颜色和模式
              Colors.grey,
              BlendMode.color,
            ),
            child: widget,
          ),
          Text(
            tip,
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w200),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8),
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "推荐给予允许/自启动&关联启动&后台活动/权限",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                Offstage(
                  offstage: true,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(Icons.save_outlined),
                        Text(" 存储权限未开启"),
                        Spacer(),
                        Icon(Icons.arrow_right_sharp)
                      ],
                    ),
                  ),
                ),
                Offstage(
                  offstage: appSetting.accessibilityEnable,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        asyncFun() async {
                          appSetting.accessibilityEnable =
                              await invokeAndroidBoolMethod(
                                  "openAccessibility");
                        }

                        asyncFun();
                      });
                    },
                    child: Row(
                      children: [
                        Icon(Icons.accessibility_new),
                        Text(" 无障碍权限未开启"),
                        Spacer(),
                        Icon(Icons.arrow_right_sharp)
                      ],
                    ),
                  ),
                ),
                Offstage(
                  offstage: appSetting.isIgnoringBatteryOptimizations,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        asyncFun() async {
                          appSetting.isIgnoringBatteryOptimizations =
                              await invokeAndroidBoolMethod(
                                  "ignoreBatteryOptimizations");
                        }

                        asyncFun();
                      });
                    },
                    child: Row(
                      children: [
                        Icon(Icons.power_off_outlined),
                        Text(" 电池白名单权限未开启"),
                        Spacer(),
                        Icon(Icons.arrow_right_sharp)
                      ],
                    ),
                  ),
                ),
                Offstage(
                  offstage: true,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        asyncFun() async {
                          // if (await openAccessibility()) {
                          //   accessibilityEnable = true;
                          // }
                        }
                        asyncFun();
                      });
                    },
                    child: Row(
                      children: [
                        Icon(Icons.notifications_off_outlined),
                        Text(" 通知权限未开启"),
                        Spacer(),
                        Icon(Icons.arrow_right_sharp)
                      ],
                    ),
                  ),
                ),
                Offstage(
                  offstage: true,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        asyncFun() async {
                          // if (await openAccessibility()) {
                          //   accessibilityEnable = true;
                          // }
                        }
                        asyncFun();
                      });
                    },
                    child: Row(
                      children: [
                        Icon(Icons.flip_to_front),
                        Text(" 悬浮窗权限未开启"),
                        Spacer(),
                        Icon(Icons.arrow_right_sharp)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        widgetEnable(
            widget: Card(
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1.6,
                    child: Image.asset("assets/images/service/postiche.jpg",
                        fit: BoxFit.cover),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage("assets/images/app.png"),
                    ),
                    title: Text("APK.1安装者"),
                    subtitle: Text(
                      "已为您服务${appSetting.apk1Count}次",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Icon(
                      Icons.done,
                      color: CupertinoColors.systemGreen,
                      size: 40,
                    ),
                  )
                ],
              ),
            ),
            enable: true,
            tip: "此功能需要存储权限"),
        widgetEnable(
            widget: Card(
              child: Column(
                children: [
                  AspectRatio(
                      aspectRatio: 1.6,
                      child: Image.asset(
                          appSetting.artworkEnable
                              ? "assets/images/service/artworker-enable.jpg"
                              : "assets/images/service/artworker.jpg",
                          fit: BoxFit.cover)),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage("assets/images/app.png"),
                    ),
                    title: Text("原图者"),
                    subtitle: Text(
                      "已为您服务${appSetting.artworkCount}次",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: CupertinoSwitch(
                      value: appSetting.artworkEnable,
                      onChanged: (bool value) {
                        setState(() {
                          appSetting.artworkEnable = value;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            enable: appSetting.accessibilityEnable,
            tip: "此功能需要无障碍权限"),
        // widgetEnable(
        //     widget: Card(
        //       child: Column(
        //         children: [
        //           AspectRatio(
        //             aspectRatio: 1.6,
        //             child: Image.asset(
        //                 appSetting.cleanerEnable
        //                     ? "assets/images/service/cleaner-enable.jpg"
        //                     : "assets/images/service/cleaner.jpg",
        //                 fit: BoxFit.cover),
        //           ),
        //           ListTile(
        //             leading: CircleAvatar(
        //               backgroundImage: AssetImage("assets/images/app.png"),
        //             ),
        //             title: Text("清理者"),
        //             subtitle: Text(
        //               "已为您服务${appSetting.cleanerCount}次",
        //               maxLines: 2,
        //               overflow: TextOverflow.ellipsis,
        //             ),
        //             trailing: CupertinoSwitch(
        //               value: appSetting.cleanerEnable,
        //               onChanged: (bool value) {
        //                 setState(() {
        //                   appSetting.cleanerEnable = value;
        //                 });
        //               },
        //             ),
        //           )
        //         ],
        //       ),
        //     ),
        //     enable: accessibilityEnable,
        //     tip: "此功能需要无障碍权限"),
        widgetEnable(
            widget: Card(
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 1.6,
                    child: Image.asset(
                        appSetting.readerEnable
                            ? "assets/images/service/reader-enable.jpg"
                            : "assets/images/service/reader.jpg",
                        fit: BoxFit.cover),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage("assets/images/app.png"),
                    ),
                    title: Text("阅读者"),
                    subtitle: Text(
                      "已为您服务${appSetting.readerCount}次",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: CupertinoSwitch(
                      value: appSetting.readerEnable,
                      onChanged: (bool value) {
                        setState(() {
                          appSetting.readerEnable = value;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            enable: appSetting.accessibilityEnable,
            tip: "此功能需要无障碍权限")
      ],
    );
  }
}
