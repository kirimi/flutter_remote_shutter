package ru.kirimi.remote_shutter_plugin

import android.view.KeyEvent
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

const val ON_PRESSED_METHOD = "onPressed"
const val SET_ENABLE_METHOD = "setEnable"
const val GET_ENABLED_METHOD = "getEnabled"

var channel: MethodChannel? = null

var isEnabled: Boolean = false

/** RemoteShutterPlugin */
class RemoteShutterPlugin : FlutterPlugin, MethodCallHandler {
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "remote_shutter_plugin")
        channel?.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            GET_ENABLED_METHOD -> {
                result.success(isEnabled)
            }
            SET_ENABLE_METHOD -> {
                val enabled = call.arguments as Boolean
                isEnabled = enabled;
                result.success(isEnabled)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
    }

}

open class RemoteShutterActivity : FlutterActivity() {
    override fun onKeyDown(keyCode: Int, event: KeyEvent): Boolean {
        if (keyCode == KeyEvent.KEYCODE_VOLUME_UP && isEnabled) {
            channel?.invokeMethod(ON_PRESSED_METHOD, event.deviceId)
            return true
        }
        return super.onKeyDown(keyCode, event)
    }
}
