import 'dart:ui';

import 'screen_defender_platform_interface.dart';

class ScreenDefenderPlugin {
  final ScreenDefenderPlatformInterface _handler = ScreenDefenderPlatformInterface.instance;

  ////////////////////////////////// Setting Secure Task View //////////////////////////////////

  /// Enable secureTaskView
  /// Supported for Android only, do nothing when run on iOS.
  Future<void> secureTaskViewOn() async {
    await _handler.secureTaskViewOn();
  }

  /// Enable secureTaskView with Image, Color, Blur
  /// Supported for iOS only, do nothing when run on Android.
  Future<void> secureTaskViewImageOn(String imageName) async {
    await _handler.secureTaskViewImageOn(imageName);
  }

  Future<void> secureTaskViewImageOff() async {
    await _handler.secureTaskViewImageOff();
  }

  Future<void> secureTaskViewColorOn(Color color) async {
    await _handler.secureTaskViewColorOn(color);
  }

  Future<void> secureTaskViewColorOff() async {
    await _handler.secureTaskViewColorOff();
  }

  Future<void> secureTaskViewBlurOn() async {
    await _handler.secureTaskViewBlurOn();
  }

  Future<void> secureTaskViewBlurOff() async {
    await _handler.secureTaskViewBlurOff();
  }

  /// Disable secureTaskView
  /// Supported for Android and iOS.
  /// In iOS, disable all secureTaskViews
  Future<void> disableSecureTaskView() async {
    await _handler.disableSecureTaskView();
  }

  ////////////////////////////////// Setting Capture Prevent View //////////////////////////////////

  /// Supported for Android and iOS.
  /// Enable Capture Prevent Image
  /// [imageName] is only for iOS.
  Future<void> capturePreventImageOn(String? imageName) async {
    await _handler.capturePreventImageOn(imageName);
  }

  /// Disable Capture Prevent Image
  Future<void> disableCapturePreventImage() async {
    await _handler.disableCapturePreventImage();
  }

  /// Supported for iOS only, do nothing when run on Android.
  Future<bool?> isRecording() async {
    final res = await _handler.isRecording();
    return res;
  }

  /// add capture, record listener
  void addListener({
    void Function()? screenshotListener,
    void Function(bool)? screenRecordListener,
  }) {
    _handler.addListener(
      screenshotListener: screenshotListener,
      screenRecordListener: screenRecordListener,
    );
  }

  /// remove capture, record listener
  void removeListener() {
    _handler.removeListener();
  }
}
