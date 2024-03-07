import 'dart:ui';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'screen_defender_method_channel.dart';

abstract class ScreenDefenderPlatformInterface extends PlatformInterface {
  /// Constructs a ScreenDefenderPlatform.
  ScreenDefenderPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static ScreenDefenderPlatformInterface _instance = MethodChannelScreenDefender();

  /// The default instance of [ScreenDefenderPlatformInterface] to use.
  ///
  /// Defaults to [MethodChannelScreenDefender].
  static ScreenDefenderPlatformInterface get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ScreenDefenderPlatformInterface] when
  /// they register themselves.
  static set instance(ScreenDefenderPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> disableSecureTaskView() {
    throw UnimplementedError('disableAllTaskView() has not been implemented.');
  }

  Future<void> secureTaskViewOn() {
    throw UnimplementedError('secureTaskViewOn() has not been implemented.');
  }

  Future<void> secureTaskViewBlurOn() {
    throw UnimplementedError('taskViewBlurOn() has not been implemented.');
  }

  Future<void> secureTaskViewBlurOff() {
    throw UnimplementedError('taskViewBlurOff() has not been implemented.');
  }

  Future<void> secureTaskViewImageOn(String imageName) {
    throw UnimplementedError('protectDataLeakageWithImage() has not been implemented.');
  }

  Future<void> secureTaskViewImageOff() {
    throw UnimplementedError('taskViewImageOff() has not been implemented.');
  }

  Future<void> secureTaskViewColorOn(Color color) {
    throw UnimplementedError('taskViewColorOn() has not been implemented.');
  }

  Future<void> secureTaskViewColorOff() {
    throw UnimplementedError('taskViewColorOff() has not been implemented.');
  }

  Future<void> disableCapturePreventImage() {
    throw UnimplementedError('disableCapturePreventImage() has not been implemented.');
  }

  Future<void> capturePreventImageOn(String? imageName) async {
    throw UnimplementedError('capturePreventImageOn() has not been implemented.');
  }

  Future<bool?> isRecording() {
    throw UnimplementedError('isRecording() has not been implemented.');
  }

  void addListener({
    void Function()? screenshotListener,
    void Function(bool)? screenRecordListener,
  }) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  void removeListener() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
