package top.mxlt.wechathelper.util;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.PowerManager;
import android.provider.Settings;
import android.text.TextUtils;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.annotation.RequiresApi;
import androidx.core.app.NotificationManagerCompat;

import io.flutter.plugin.common.MethodChannel;

public class SystemUtil {

    /**
     * 打开无障碍,返回当前的无障碍开关状态
     *
     * @param ct
     * @param service
     * @return
     */
    public static boolean openAccessibility(final Context ct, final Class service) {
        boolean accessibility = checkAccessibility(ct, service);
        if (!accessibility) {
            jumpAccessibilitySetting(ct);
        }
        return accessibility;
    }

    /**
     * 判断Accessibility是否开启
     *
     * @param ct
     * @param serviceClass
     * @return
     */
    public static boolean checkAccessibility(Context ct, Class serviceClass) {
        int ok = 0;
        try {
            ok = Settings.Secure.getInt(ct.getContentResolver(), Settings.Secure.ACCESSIBILITY_ENABLED);
        } catch (Settings.SettingNotFoundException e) {
        }

        TextUtils.SimpleStringSplitter ms = new TextUtils.SimpleStringSplitter(':');
        if (ok == 1) {
            String settingValue = Settings.Secure.getString(ct.getContentResolver(), Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES);
            if (settingValue != null) {
                ms.setString(settingValue);
                while (ms.hasNext()) {
                    String accessibilityService = ms.next();
                    if (accessibilityService.contains(serviceClass.getSimpleName())) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    public static void jumpAccessibilitySetting(Context ct) {
        // jump to tool permission
        Intent intent = new Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        ct.startActivity(intent);
        Toast.makeText(ct, "请手动授予我信助手无障碍权限", Toast.LENGTH_SHORT).show();
    }


    /**
     * 判断忽略电池优化是否开启
     *
     * @param ct
     * @return
     */
    @RequiresApi(api = Build.VERSION_CODES.M)
    public static boolean isIgnoringBatteryOptimizations(Context ct) {
        PowerManager powerManager = (PowerManager) ct.getSystemService(Context.POWER_SERVICE);
        return powerManager != null && powerManager.isIgnoringBatteryOptimizations(ct.getPackageName());
    }

    /**
     * 忽略电池优化,返回当前的电池优化开关状态
     *
     * @param ct
     * @return
     */
    @RequiresApi(api = Build.VERSION_CODES.M)
    public static boolean ignoreBatteryOptimizations(Context ct) {
        PowerManager powerManager = (PowerManager) ct.getSystemService(Context.POWER_SERVICE);
        boolean result = powerManager != null && powerManager.isIgnoringBatteryOptimizations(ct.getPackageName());
        if (!result) {
            try {
                Intent intent = new Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
                intent.setData(Uri.parse("package:" + ct.getPackageName()));
                ct.startActivity(intent);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }

    //调用该方法获取是否开启通知栏权限
    public static boolean isNotifyEnabled(Context context) {
        return NotificationManagerCompat.from(context).areNotificationsEnabled();
    }

    public static boolean openNotify(Context context) {
        if (!isNotifyEnabled(context)) {
            Intent localIntent = new Intent();
            //判断API，跳转到应用通知管理页面
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {//8.0及以上
                localIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                localIntent.setAction("android.settings.APPLICATION_DETAILS_SETTINGS");
                localIntent.setData(Uri.fromParts("package", context.getPackageName(), null));
            } else if (android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {//8.0以下
                localIntent.setAction("android.settings.APP_NOTIFICATION_SETTINGS");
                localIntent.putExtra("app_package", context.getPackageName());
                localIntent.putExtra("app_uid", context.getApplicationInfo().uid);
            }
            context.startActivity(localIntent);
            Toast.makeText(context, "请先授予我信助手通知权限", Toast.LENGTH_SHORT).show();

            return false;

        }
        return true;
    }


    /****************
     *
     * 获取群Key: https://qun.qq.com/join.html
     * 调用 joinQQGroup(key) 即可发起手Q客户端申请加群
     *
     * @param key 由官网生成的key
     * @return 返回true表示呼起手Q成功，返回false表示呼起失败
     ******************/
    public boolean joinQQGroup(Context context, String key) {
        Intent intent = new Intent();
        //因为我把群解散了, 所以这里作废
        //intent.setData(Uri.parse("mqqopensdkapi://bizAgent/qm/qr?url=http%3A%2F%2Fqm.qq.com%2Fcgi-bin%2Fqm%2Fqr%3Ffrom%3Dapp%26p%3Dandroid%26jump_from%3Dwebapi%26k%3D" + key));
        intent.setData(Uri.parse("" + key));
        // 此Flag可根据具体产品需要自定义，如设置，则在加群界面按返回，返回手Q主界面，不设置，按返回会返回到呼起产品界面    //intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        try {
            context.startActivity(intent);
            return true;
        } catch (Exception e) {
            // 未安装手Q或安装的版本不支持
            return false;
        }
    }

    /****************
     *
     * 发起添加群流程。群号：我信助手(907300203) 的 key 为： 4l1ldPufTOt04NWVVbHfZmUy9om6MZrc
     * 调用 joinQQGroup(4l1ldPufTOt04NWVVbHfZmUy9om6MZrc) 即可发起手Q客户端申请加群 微信助手(907300203)
     *
     * @return 返回true表示呼起手Q成功，返回false表示呼起失败
     ******************/
    public static boolean joinQQGroup(Context context) {
        String key = "4l1ldPufTOt04NWVVbHfZmUy9om6MZrc";
        Intent intent = new Intent();
        intent.setData(Uri.parse("mqqopensdkapi://bizAgent/qm/qr?url=http%3A%2F%2Fqm.qq.com%2Fcgi-bin%2Fqm%2Fqr%3Ffrom%3Dapp%26p%3Dandroid%26jump_from%3Dwebapi%26k%3D" + key));
        // 此Flag可根据具体产品需要自定义，如设置，则在加群界面按返回，返回手Q主界面，不设置，按返回会返回到呼起产品界面    //intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        try {
            context.startActivity(intent);
            return true;
        } catch (Exception e) {
            // 未安装手Q或安装的版本不支持
            return false;
        }
    }

}
