package top.mxlt.wechathelper;

import android.Manifest.permission;
import android.app.PendingIntent;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;
import androidx.core.content.PermissionChecker;

import com.gyf.cactus.Cactus;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.channels.FileChannel;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import top.mxlt.wechathelper.util.PreferencesUtils;
import top.mxlt.wechathelper.util.SystemUtil;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "wechathelper";
    private static final int EXTERNAL_STORAGE_PERMISSION = 1001;
    private static Cactus instance;
    String fileUrl;
    private InstallCompleteReceiver installCompleteReceiver = new InstallCompleteReceiver();

    public static MethodChannel methodChannel;


    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
    }


    /**
     * 软件第一次打开的时候
     */
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (ContextCompat.checkSelfPermission(this, permission.READ_EXTERNAL_STORAGE) != PermissionChecker.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, new String[]{permission.READ_EXTERNAL_STORAGE}, EXTERNAL_STORAGE_PERMISSION);
        }
        installIntentApp(getIntent());
        Log.i("生命周期", "onCreate");

        //注册免杀
        startCactus();

    }

    private void startCactus() {
        if (instance != null) {
            return;
        }
//        PendingIntent activity = PendingIntent.getActivity(this, 0, this.getIntent(), PendingIntent.FLAG_UPDATE_CURRENT);
        PendingIntent activity = PendingIntent.getActivity(this, 0, this.getIntent(), PendingIntent.FLAG_MUTABLE);
        instance = Cactus.getInstance();
        instance
//                .isDebug(true)
                .setMusicEnabled(false)
                .setBackgroundMusicEnabled(false)
                .setChannelId("KeepAlive")
                .setChannelName("我信助手 保活通知")
                .setLargeIcon(R.mipmap.ic_launcher_foreground)
//                .setSmallIcon(R)
                .setTitle("我信助手")
                .setContent("通过一条通知避免应用被系统杀死")
                .setPendingIntent(activity)
                .setCrashRestartUIEnabled(true)
                .register(this);
    }

    private void stopCactus() {
        if (instance != null) {
            instance.unregister(this);
        }
    }

    /**
     * 软件已运行,重新回到前台
     */
    @Override
    protected void onRestart() {
        Log.i("生命周期", "onRestart");
        Log.i("保活程序", String.valueOf(instance == null ? false : instance.isRunning(this)));
        super.onRestart();

    }

    /**
     * 软件已运行,重新回到前台
     */
    @Override
    protected void onResume() {
        Log.i("生命周期", "onResume");

        super.onResume();
    }

    /**
     * 软件关闭前
     */
    @Override
    protected void onDestroy() {
//        stopCactus();

        Log.i("生命周期", "onDestroy");

        super.onDestroy();
    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
        intent.getAction();
        installIntentApp(intent);
    }


    @RequiresApi(api = Build.VERSION_CODES.M)
    @Override
    protected void onStart() {


        registerInstallReceiver();

        //TODO 无障碍
//        AccessibilityUtil.openAccessibility(this,AutoService.class);
//        if (methodChannel == null) {
//            methodChannel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL);
//        }
        methodChannel = new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL);

        methodChannel.setMethodCallHandler((call, result) -> {
            switch (call.method) {
                case "openAccessibility":
                    result.success(SystemUtil.openAccessibility(getContext(), AutoService.class));
                    break;
                case "checkAccessibility":
                    result.success(SystemUtil.checkAccessibility(getContext(), AutoService.class));
                    break;
                case "ignoreBatteryOptimizations":
                    result.success(SystemUtil.ignoreBatteryOptimizations(getContext()));
                    break;
                case "checkBatteryOptimizations":
                    result.success(SystemUtil.isIgnoringBatteryOptimizations(getContext()));
                    break;
                case "joinQQGroup":
                    result.success(SystemUtil.joinQQGroup(getContext()));
                    break;
                default:
                    result.notImplemented();
                    break;
            }
        });

        //开启通知权限
//        if (SystemUtil.openNotify(this)) {
//
//        }
        super.onStart();
    }

    @Override
    protected void onStop() {
        unregisterReceiver(installCompleteReceiver);
        super.onStop();
    }

    private void installIntentApp(@NonNull Intent intent) {
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        System.out.println(intent);
        if (intent.getData() != null) {
            File apkFile = uriToApkFile(this, intent.getData());
            fileUrl = apkFile.getAbsolutePath();
            System.out.println(apkFile.getAbsolutePath());
            installApp(apkFile);
            PreferencesUtils.putLong(this, "flutter.AppSetting.apk1.count", PreferencesUtils.getLong(this, "flutter.AppSetting.apk1.count") + 1);
            invokeFlutterMethod(this, "app1CountAdd", "test android");

        }
    }

    public void invokeFlutterMethod(Context context, String method, @Nullable Object arguments) {

        methodChannel.invokeMethod(method, arguments, new MethodChannel.Result() {
            @Override
            public void success(Object o) {
//                Toast.makeText(context, "methodChannel(A->F)返回值:" + o.toString(), Toast.LENGTH_LONG).show();
            }

            @Override
            public void error(String s, String s1, Object o) {
            }

            @Override
            public void notImplemented() {
            }
        });
    }

    private void invokeFlutterMethod(Context context, String method, @Nullable Object arguments, @Nullable MethodChannel.Result callback) {
        if (methodChannel != null) {
            methodChannel.invokeMethod(method, arguments, callback);
        }
    }

    private void installApp(File apkFile) {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
        Uri uri = FileProvider.getUriForFile(this, "top.mxlt.wechathelper.fileprovider", apkFile);
        intent.setDataAndType(uri, "application/vnd.android.package-archive");
        startActivity(intent);

    }

    // 注册安装结束的事件监听，用于清除缓存文件
    private void registerInstallReceiver() {
        IntentFilter intentFilter = new IntentFilter();
        intentFilter.addAction(Intent.ACTION_PACKAGE_ADDED);
        intentFilter.addAction(Intent.ACTION_PACKAGE_REMOVED);
        intentFilter.addDataScheme("package");
        getContext().registerReceiver(installCompleteReceiver, intentFilter);
    }

    private File uriToApkFile(Context context, Uri apk1Uri) {
        String cacheDataDir = context.getCacheDir().getAbsolutePath();
        String fileName = extractApkFileName(apk1Uri);
        if (!TextUtils.isEmpty(fileName)) {
            File copyApkFile = new File(cacheDataDir + File.separator + fileName);
            uriToFile(this, apk1Uri, copyApkFile);
            return copyApkFile;
        } else {
            throw new RuntimeException("");
        }
    }

    private String extractApkFileName(Uri apk1Uri) {
        if (!apk1Uri.getPath().contains(".apk.1")) {
            throw new RuntimeException("unknown apk file:" + apk1Uri.getPath());
        }
        String realName = "";
        String path = apk1Uri.getPath();
        int home = path.lastIndexOf(File.separator);
        int end = path.lastIndexOf('k');
        realName = path.substring(home, end + 1);
        return realName;
    }

    private static void uriToFile(Context context, Uri apk1Uri, File dest) {
        FileChannel inputChannel = null;

        FileChannel outputChannel = null;
        try {
            //解析参数uri的是File:// 还是 Content://
            if (ContentResolver.SCHEME_FILE.equals(apk1Uri.getScheme())) {
                //需要读取存储权限
                inputChannel = new FileInputStream(apk1Uri.getPath()).getChannel();
            } else if (ContentResolver.SCHEME_CONTENT.equals(apk1Uri.getScheme())) {
                FileInputStream inputStream = (FileInputStream) context.getContentResolver().openInputStream(apk1Uri);
                inputChannel = inputStream.getChannel();
            }
            outputChannel = new FileOutputStream(dest).getChannel();
            outputChannel.transferFrom(inputChannel, 0, inputChannel.size());
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (inputChannel != null) {
                    inputChannel.close();
                }
                if (outputChannel != null) {
                    outputChannel.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}
