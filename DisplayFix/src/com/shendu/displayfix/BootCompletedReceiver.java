package com.shendu.displayfix;

import java.io.IOException;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.SystemClock;
import android.util.Log;
import android.os.SystemProperties;

/**
 * 
 * @author chenlei
 * This is to fix u8860 and c8860 resolution can not auto set to 480X854
 * Neet to excute a shell command to force to set the right resolution.
 */

public class BootCompletedReceiver extends BroadcastReceiver {

    private static final String TAG = "DisplayFix";

    private static final String CMD_DISPLAYFIX = "am display-size 854x480";
    private static final String CMD_SET_PROP = "setprop persist.shendu.displayfix 1";
    private static final String PROP_DISPLAYFIX = "persist.shendu.displayfix";
    @Override
    public void onReceive(Context context, Intent intent) {
        try {
            SuCommander cmd = new SuCommander();
            //check prop values just set at first boot.
            String value = SystemProperties.get(PROP_DISPLAYFIX,"0");
            if (!value.isEmpty() && value != null && "0".equals(value)) {
                cmd.exec(CMD_DISPLAYFIX);
                while (!cmd.isReady()) {
                    SystemClock.sleep(200);
                }
                if (!cmd.isSuccess()) {
                    Log.d(TAG, "Err-cmd1:"+cmd.getErrors());
                }else {
                    cmd.exec(CMD_SET_PROP);
                    if (!cmd.isSuccess()) {
                        Log.d(TAG, "Err-cmd2:"+cmd.getErrors());
                    }
                    Log.d(TAG, "Res:"+cmd.getOutput());
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
