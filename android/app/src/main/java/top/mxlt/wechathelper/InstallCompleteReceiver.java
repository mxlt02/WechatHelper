package top.mxlt.wechathelper;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import java.io.File;


public class InstallCompleteReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        System.out.println(context.getCacheDir().listFiles());
//        context.unregisterReceiver(this);
        for (File file : context.getCacheDir().listFiles()) {
            System.out.println(file.getAbsolutePath());
            file.delete();
        }
        System.out.println(context.getCacheDir().listFiles());
    }

}