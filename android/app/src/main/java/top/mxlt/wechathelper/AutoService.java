package top.mxlt.wechathelper;

import android.accessibilityservice.AccessibilityService;
import android.accessibilityservice.AccessibilityServiceInfo;
import android.content.Context;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;
import android.view.accessibility.AccessibilityEvent;
import android.view.accessibility.AccessibilityNodeInfo;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;

import java.util.List;

import io.flutter.plugin.common.MethodChannel;
import top.mxlt.wechathelper.util.PreferencesUtils;

public class AutoService extends AccessibilityService {
    //    private Coun thread = new Thread();
    private String currentClassName = "";
    private boolean cleanerWorkFlag = false;
    private Thread cleanerThread;

    private void invokeFlutterMethod(Context context, String method, @Nullable Object arguments) {
        if (MainActivity.methodChannel == null) {
//            Toast.makeText(context, "methodChannel is null", Toast.LENGTH_LONG).show();
            return;
        }

        MainActivity.methodChannel.invokeMethod(method, arguments, new MethodChannel.Result() {
            @Override
            public void success(Object o) {
//                Toast.makeText(context, "methodChannel(A->F)返回值:" + o.toString(), Toast.LENGTH_LONG).show();
            }

            @Override
            public void error(String s, String s1, Object o) {
                Toast.makeText(context, "调用失败error" + o.toString(), Toast.LENGTH_LONG).show();
            }

            @Override
            public void notImplemented() {
                Toast.makeText(context, "调用失败notImplemented" , Toast.LENGTH_LONG).show();
            }
        });
    }

    @Override
    protected void onServiceConnected() {
        AccessibilityServiceInfo config = new AccessibilityServiceInfo();
        //配置监听的事件类型为界面变化|点击事件
        config.eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED;
        config.packageNames = new String[]{"com.tencent.mm"};
        config.feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC;
        if (Build.VERSION.SDK_INT >= 16) {
            config.flags = AccessibilityServiceInfo.FLAG_INCLUDE_NOT_IMPORTANT_VIEWS;
        }
        setServiceInfo(config);
        super.onServiceConnected();
    }

    private boolean isActivity(AccessibilityEvent event) {
        String className = event.getClassName().toString();
        return !className.startsWith("android.") && !className.startsWith("androidx.");
    }

//    private boolean isWXUI(AccessibilityEvent event) {
//        return isActivity(event) && "com.tencent.mm".equals(event.getPackageName());
//    }

//    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
//    public void clickByText(AccessibilityNodeInfo info, String targetText) {
//        if (info.getChildCount() == 0) {
//            if (info.getText() != null && info.getText().toString().contains(targetText)) {
//                click(info);
//            }
//
//            Log.i("TAG", "child widget----------------------------" + info.getClassName());
//            Log.i("TAG", "showDialog:" + info.canOpenPopup());
//            Log.i("TAG", "Text：" + info.getText());
//            Log.i("TAG", "windowId:" + info.getWindowId());
//        } else {
//            for (int i = 0; i < info.getChildCount(); i++) {
//                if (info.getChild(i) != null) {
//                    clickByText(info.getChild(i), targetText);
//                }
//            }
//        }
//    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    @Override
    public void onAccessibilityEvent(AccessibilityEvent event) {
        final AccessibilityNodeInfo nodeInfo = event.getSource();//当前界面的可访问节点信息
//        final AccessibilityNodeInfo nodeInfo = getRootInActiveWindow();//当前界面的可访问节点信息
        if (nodeInfo == null) {
            Log.i("TAG", "nodeInfo is　null");
            return;
        }

//        nodeInfo.getWindow();
//        if (event.getEventType() == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {//界面变化事件
        if (true) {//界面变化事件

            //TEST
            if (isActivity(event)) {
//            if (isWXUI(event)) {
                currentClassName = event.getClassName().toString();
                switch (event.getClassName().toString()) {
                    //[阅读者]自动点击转文字
                    case "com.tencent.mm.ui.LauncherUI":
                        if (PreferencesUtils.getBoolean(this, "flutter.AppSetting.reader.enable")) {
                            Handler handler = new Handler(Looper.getMainLooper());
                            new Thread() {
                                @Override
                                public void run() {
                                    while (currentClassName.equals("com.tencent.mm.ui.LauncherUI")) {
                                        handler.postDelayed(() -> clickReader(nodeInfo.findAccessibilityNodeInfosByViewId("com.tencent.mm:id/b5f")), 20);
                                        System.out.println(currentClassName);
                                        try {
                                            System.out.println(currentClassName);
                                            Thread.sleep(1000);
                                        } catch (InterruptedException e) {
                                            e.printStackTrace();
                                        }
                                    }
                                }
                            }.start();
                        }
                        break;
                    //[原图者]发送图片页面
                    case "com.tencent.mm.plugin.gallery.ui.AlbumPreviewUI":
                        if (PreferencesUtils.getBoolean(this, "flutter.AppSetting.artwork.enable")) {
                            new Handler(Looper.getMainLooper()).postDelayed(() -> clickArtwork(nodeInfo.findAccessibilityNodeInfosByViewId("com.tencent.mm:id/hp6")), 10);
                        }
                        break;
                    //[原图者]可能要发送的发送图片页面
                    case "com.tencent.mm.plugin.gallery.ui.ImagePreviewUI":
                        if (PreferencesUtils.getBoolean(this, "flutter.AppSetting.artwork.enable")) {
                            new Handler(Looper.getMainLooper()).postDelayed(() -> clickArtwork(nodeInfo.findAccessibilityNodeInfosByViewId("com.tencent.mm:id/hp6")), 10);
                        }
                        break;
                    //[原图者]查看图片页面
                    case "com.tencent.mm.ui.chatting.gallery.ImageGalleryUI":
                        if (PreferencesUtils.getBoolean(this, "flutter.AppSetting.artwork.enable")) {
                            Handler handler = new Handler(Looper.getMainLooper());
                            new Thread() {
                                @Override
                                public void run() {
                                    while (currentClassName.equals("com.tencent.mm.ui.chatting.gallery.ImageGalleryUI")) {
                                        handler.postDelayed(() -> clickArtwork(nodeInfo.findAccessibilityNodeInfosByViewId("com.tencent.mm:id/bx5")), 20);
                                        System.out.println(currentClassName);
                                        try {
                                            System.out.println(currentClassName);
                                            Thread.sleep(200);
                                        } catch (InterruptedException e) {
                                            e.printStackTrace();
                                        }
                                    }
                                }
                            }.start();
                        }
                        break;
//                    //[清理者]关闭朋友圈广告
//                    case "com.tencent.mm.plugin.sns.ui.SnsTimeLineUI":
//                        break;
//                    //[清理者]关闭朋友圈广告
//                    case "android.widget.FrameLayout":
//                        break;
//                    //[清理者]公众号文章内嵌广告
//                    case "com.tencent.mm.plugin.brandservice.ui.timeline.preload.ui.TmplWebViewTooLMpUI":
//                        break;
                    default:
                        break;
                }
            }
        }
    }

    private void clickReader(List<AccessibilityNodeInfo> nodeInfoList) {
        Log.d("WindowChange", "数据" + nodeInfoList.size());
        if (nodeInfoList != null && nodeInfoList.size() > 0) {
            for (AccessibilityNodeInfo nodeInfo : nodeInfoList) {
                nodeInfo.performAction(AccessibilityNodeInfo.ACTION_CLICK);
                Toast.makeText(getApplicationContext(), "我信助手 阅读者", Toast.LENGTH_SHORT).show();
                invokeFlutterMethod(this, "readerCountAdd", "test android");
//                PreferencesUtils.putInt(this,"flutter.AppSetting.reader.count",PreferencesUtils.getInt(this,"flutter.AppSetting.reader.count")+1);
            }

        }
    }

    private void clickArtwork(List<AccessibilityNodeInfo> nodeInfoList) {
        Log.d("WindowChange", "数据" + nodeInfoList.size());
        if (nodeInfoList != null && nodeInfoList.size() > 0) {
            for (AccessibilityNodeInfo nodeInfo : nodeInfoList) {
                if (nodeInfo.getContentDescription() != null && nodeInfo.getContentDescription().toString().contains("已选中,原图,复选框")) {
                    continue;
                }
                nodeInfo.performAction(AccessibilityNodeInfo.ACTION_CLICK);
                Toast.makeText(getApplicationContext(), "我信助手 原图者", Toast.LENGTH_SHORT).show();
                invokeFlutterMethod(this, "artworkCountAdd", "test android");
//                PreferencesUtils.putInt(this,"flutter.AppSetting.artwork.count",PreferencesUtils.getInt(this,"flutter.AppSetting.artwork.count")+1);
            }

        }
    }


//    private void click(List<AccessibilityNodeInfo> nodeInfoList) {
//        Log.d("WindowChange", "数据" + nodeInfoList.size());
//        if (nodeInfoList != null && nodeInfoList.size() > 0) {
//            for (AccessibilityNodeInfo nodeInfo : nodeInfoList) {
//                nodeInfo.performAction(AccessibilityNodeInfo.ACTION_CLICK);
//                Toast.makeText(getApplicationContext(), "我信助手", Toast.LENGTH_SHORT).show();
//            }
//        }
//    }
//
//    private void click(AccessibilityNodeInfo nodeInfo) {
//        Log.d("WindowChange", "数据" + nodeInfo);
//        if (nodeInfo != null) {
//            if (nodeInfo.getContentDescription() != null && nodeInfo.getContentDescription().toString().contains("已选中")) {
//                return;
//            }
//            nodeInfo.performAction(AccessibilityNodeInfo.ACTION_CLICK);
//            Toast.makeText(getApplicationContext(), "我信助手", Toast.LENGTH_SHORT).show();
//        }
//    }

//    private ActivityInfo tryGetActivity(ComponentName componentName) {
//        try {
//            return getPackageManager().getActivityInfo(componentName, 0);
//        } catch (PackageManager.NameNotFoundException e) {
//            return null;
//        }
//    }

    @Override
    public void onInterrupt() {
    }
}
