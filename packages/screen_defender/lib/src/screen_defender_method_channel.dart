import 'package:flutter/services.dart';

import '../extension/color.dart';
import 'screen_defender_platform_interface.dart';

/// An implementation of [ScreenDefenderPlatformInterface] that uses method channels.
class MethodChannelScreenDefender extends ScreenDefenderPlatformInterface {
  /// The method channel used to interact with the native platform.
  final _channel = const MethodChannel('screen_defender');

  static void Function()? _onScreenshotListener;
  static void Function(bool)? _onScreenRecordListener;

  /// Add callback actions when screenshot or screen record events received,
  /// Supported for iOS only, do nothing when run on Android.
  @override
  Future<void> addListener({
    void Function()? screenshotListener,
    void Function(bool)? screenRecordListener,
  }) async {
    _onScreenshotListener = screenshotListener;
    _onScreenRecordListener = screenRecordListener;

    _channel.setMethodCallHandler(_methodCallHandler);
    await _channel.invokeMethod('addListener');
  }

  /// Remove listeners
  void _removeListener() {
    _onScreenshotListener = null;
    _onScreenRecordListener = null;
  }

  /// Remove observers
  /// Supported for iOS only, do nothing when run on Android.
  @override
  Future<void> removeListener() async {
    _removeListener();
    await _channel.invokeMethod('removeListener');
  }

  Future<dynamic> _methodCallHandler(MethodCall call) async {
    if (call.method == 'onScreenshot') {
      if (null != _onScreenshotListener) {
        _onScreenshotListener!();
      }
    } else if (call.method == 'onScreenRecord') {
      final isCaptured = call.arguments;
      if (null != _onScreenRecordListener &&
          isCaptured != null &&
          isCaptured is bool) {
        _onScreenRecordListener!(isCaptured);
      }
    }
  }

  /// Supported for Android and iOS.
  @override
  Future<void> capturePreventImageOn(String? imageName) async {
    await _channel.invokeMethod('capturePreventImageOn', {
      'image': imageName,
    });
  }

  /// Supported for Android and iOS.
  @override
  Future<void> disableCapturePreventImage() async {
    await _channel.invokeMethod('disableCapturePreventImage');
  }

  /// Supported for Android only, do nothing when run on iOS.
  /// Android 는 os 제공 플래그로 화면을 가림
  @override
  Future<void> secureTaskViewOn() async {
    await _channel.invokeMethod('secureTaskViewOn');
  }

  /// Supported for Android and iOS.
  @override
  Future<void> disableSecureTaskView() async {
    await _channel.invokeMethod('disableSecureTaskView');
  }

  /// Supported for iOS only, do nothing when run on Android.
  @override
  Future<void> secureTaskViewBlurOn() async {
    await _channel.invokeMethod('protectDataLeakageWithBlur');
  }

  /// Supported for iOS only, do nothing when run on Android.
  @override
  Future<void> secureTaskViewBlurOff() async {
    await _channel.invokeMethod('protectDataLeakageWithBlurOff');
  }

  /// Supported for iOS only, do nothing when run on Android.
  @override
  Future<void> secureTaskViewImageOn(String imageName) async {
    await _channel.invokeMethod('protectDataLeakageWithImage', {
     'image': imageName,
    });
  }

  /// Supported for iOS only, do nothing when run on Android.
  @override
  Future<void> secureTaskViewImageOff() async {
    await _channel.invokeMethod('protectDataLeakageWithImageOff');
  }

  /// Supported for iOS only, do nothing when run on Android.
  @override
  Future<void> secureTaskViewColorOn(Color color) async {
    await _channel.invokeMethod('protectDataLeakageWithColor', {
      'hexColor': color.toHex(),
    });
  }

  /// Supported for iOS only, do nothing when run on Android.
  @override
  Future<void> secureTaskViewColorOff() async {
    await _channel.invokeMethod('protectDataLeakageWithColorOff');
  }

  /// Supported for iOS only, do nothing when run on Android.
  @override
  Future<bool?> isRecording() async {
    final res = await _channel.invokeMethod<bool?>('isRecording');
    return res;
  }
}
