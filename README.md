# 我信助手

> Author:AlanZhao.
>

## Getting Started

```
flutter build apk --split-per-abi
flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi
```

> - **x86_64：** Intel 64 位，一般用于平板或者模拟器，支持 x86 以及 x86_64 CPU 架构设备。
> - **arm64-v8a：** 第 8 代 64 位，包含 AArch32、AArch64 两个执行状态，且对应 32 、64 bit，并且支持 armeabi、armeabi-v7a 以及 arm64-v8a。
> - **armeabi-v7a：** 第 7 代 arm v7，使用硬件浮点运算，具有高级拓展功能，兼容 armeabi 以及 armeabi-v7a，而且目前大部分手机都是这个架构。

## 开发计划

> - 涉及到无障碍权限的服务在开启时确实是可以跳转判断开启, 但是如果软件重启了呢? 无障碍是关闭的, 但软件设置确是开启.
>
> - 微信更新后组件ID会变化,应该多使用findAccessibilityNodeInfosByText("直接关闭"),保证软件的通用性
>
> - 清晰者首次开关会黑白闪烁, 怀疑是创建对象的延迟导致的
>
> - 订阅号消息页面的广告
>
> - 公众号文字底部的广告
>
> - 避免被关闭,学习SMSForwarder
>
> - 隐藏后台,满足有些的需求,也能避免被误杀
>
> - ```dart
>       Offstage(
>         offstage: 布尔值,    当为true时,将隐藏组件且不保留空间位置
>         child: 组件,
>       )
>   
>     class _HomeState extends State<Home> {
>       @override
>       Widget build(BuildContext context) {
>         return Container(
>            child: ListView(
>              children: <Widget>[
>   
>                Offstage(
>                  offstage: true,
>                  child: Text('ahh'),
>                ),
>                Text('bb')
>              ],
>            ),
>         );
>       }
>     }
>   ```
>

