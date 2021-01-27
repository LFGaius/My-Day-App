package com.lfgapps.my_day_app

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.*


class MainActivity: FlutterActivity() {
    private val CHANNEL = "myday.app/channel"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getTimeZoneName") {
                result.success(TimeZone.getDefault().getID())
            } else {
                result.notImplemented()
            }
        }
    }
}
