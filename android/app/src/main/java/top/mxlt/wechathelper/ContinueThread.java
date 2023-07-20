//package top.mxlt.wechathelper;
//
//import android.view.accessibility.AccessibilityEvent;
//
//public class ContinueThread extends Thread {
//    private AccessibilityEvent event;
//
//    public ContinueThread(AccessibilityEvent event) {
//        this.event = event;
//    }
//
//    @Override
//    public void run() {
//        System.out.println(event);
//        while (true) {
//            try {
//                sleep(500);
//            } catch (InterruptedException e) {
//                e.printStackTrace();
//            }
//        }
//    }
//}
