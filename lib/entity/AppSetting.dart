import 'package:flutter/services.dart';
import 'package:wechat_helper/util/LocalStorageUtil.dart';

class AppSetting {
  static const methodChannel = MethodChannel('wechathelper');

  bool _inited = false;
  int _apk1Count = 0;
  bool _artworkEnable = false;
  int _artworkCount = 0;
  bool _cleanerEnable = false;
  int _cleanerCount = 0;
  bool _readerEnable = false;
  int _readerCount = 0;
  bool _isIgnoringBatteryOptimizations = false;
  bool _accessibilityEnable = false;

  AppSetting() {
    init();
  }

  bool get inited => _inited;

  set inited(bool value) {
    _inited = value;
  }

  init() async {
    int? apk1Count = await LocalStorageUtil.getInt("AppSetting.apk1.count");
    if (apk1Count != null) {
      this.apk1Count = apk1Count;
    } else {
      LocalStorageUtil.setInt("AppSetting.apk1.count", this.apk1Count);
    }

    bool? artworkEnable =
        await LocalStorageUtil.getBool("AppSetting.artwork.enable");
    if (artworkEnable != null) {
      this.artworkEnable = artworkEnable;
    } else {
      LocalStorageUtil.setBool("AppSetting.artwork.enable", this.artworkEnable);
    }

    int? artworkCount =
        await LocalStorageUtil.getInt("AppSetting.artwork.count");
    if (artworkCount != null) {
      this.artworkCount = artworkCount;
    } else {
      LocalStorageUtil.setInt("AppSetting.artwork.count", this.artworkCount);
    }

    bool? cleanerEnable = await LocalStorageUtil.getBool("AppSetting.cleaner.enable");
    if (cleanerEnable != null) {
      this.cleanerEnable = cleanerEnable;
    } else {
      LocalStorageUtil.setBool("AppSetting.cleaner.enable", this.cleanerEnable);
    }

    int? cleanerCount =
        await LocalStorageUtil.getInt("AppSetting.cleaner.count");
    if (cleanerCount != null) {
      this.cleanerCount = cleanerCount;
    } else {
      LocalStorageUtil.setInt("AppSetting.cleaner.count", this.cleanerCount);
    }

    bool? readerEnable = await LocalStorageUtil.getBool("AppSetting.reader.enable");
    if (readerEnable != null) {
      this.readerEnable = readerEnable;
    } else {
      LocalStorageUtil.setBool("AppSetting.reader.enable", this.readerEnable);
    }

    int? readerCount = await LocalStorageUtil.getInt("AppSetting.reader.count");
    if (readerCount != null) {
      this.readerCount = readerCount;
    } else {
      LocalStorageUtil.setInt("AppSetting.reader.count", this.readerCount);
    }

    isIgnoringBatteryOptimizations =
        await invokeAndroidBoolMethod("checkBatteryOptimizations");
    accessibilityEnable = await invokeAndroidBoolMethod("checkAccessibility");
    print("初始化完成");
    inited = true;
  }

//方法通道的方法是异步的
  Future<bool> invokeAndroidBoolMethod(String methodName) async {
    bool result = await methodChannel.invokeMethod(methodName);
    return result;
  }

  int get apk1Count {
    // asyncFunction() async{
    //   _apk1Count = (await LocalStorageUtil.getInt("AppSetting.apk1.count"))!;
    // }
    return _apk1Count;
  }

  set apk1Count(int value) {
    if (_apk1Count != value) {
      _apk1Count = value;
      LocalStorageUtil.setInt("AppSetting.apk1.count", _apk1Count);
    }
  }

  bool get artworkEnable => _artworkEnable;

  set artworkEnable(bool value) {
    if (_artworkEnable != value) {
      _artworkEnable = value;
      LocalStorageUtil.setBool("AppSetting.artwork.enable", _artworkEnable);
    }
  }

  int get artworkCount => _artworkCount;

  set artworkCount(int value) {
    if (_artworkCount != value) {
      _artworkCount = value;
      LocalStorageUtil.setInt("AppSetting.artwork.count", _artworkCount);
    }
  }

  bool get cleanerEnable => _cleanerEnable;

  set cleanerEnable(bool value) {
    if (_cleanerEnable != value) {
      _cleanerEnable = value;
      LocalStorageUtil.setBool("AppSetting.cleaner.enable", _cleanerEnable);
    }
  }

  int get cleanerCount => _cleanerCount;

  set cleanerCount(int value) {
    if (_cleanerCount != value) {
      _cleanerCount = value;
      LocalStorageUtil.setInt("AppSetting.cleaner.count", _cleanerCount);
    }
  }

  bool get isIgnoringBatteryOptimizations => _isIgnoringBatteryOptimizations;

  set isIgnoringBatteryOptimizations(bool value) {
    _isIgnoringBatteryOptimizations = value;
  }

  int get readerCount => _readerCount;

  set readerCount(int value) {
    if (_readerCount != value) {
      _readerCount = value;
      LocalStorageUtil.setInt("AppSetting.reader.count", _readerCount);
    }
  }

  bool get readerEnable => _readerEnable;

  set readerEnable(bool value) {
    if (_readerEnable != value) {
      _readerEnable = value;
      LocalStorageUtil.setBool("AppSetting.reader.enable", _readerEnable);
    }
  }

  bool get accessibilityEnable => _accessibilityEnable;

  set accessibilityEnable(bool value) {
    _accessibilityEnable = value;
  }
}
