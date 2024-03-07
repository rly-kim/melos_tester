package com.kt.startkit.screen_defender

import androidx.annotation.NonNull

import android.app.Activity
import android.view.WindowManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** ScreenDefenderPlugin */
class ScreenDefenderPlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var activity: Activity? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "screen_defender")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "secureTaskViewOn", "capturePreventImageOn" -> {
        try {
          activity?.window?.setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE,
          )
          result.success(true)
        } catch (_: Exception) {
          result.success(false)
        }
      }
      "disableSecureTaskView", "disableCapturePreventImage" -> {
        try {
          activity?.window?.clearFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
          )
          result.success(true)
        } catch (_: Exception) {
          result.success(false)
        }
      }
      "isRecording" -> {
        // Not supported.
        result.success(false)
      }
      else -> result.success(false)
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onDetachedFromActivity() {}
}
