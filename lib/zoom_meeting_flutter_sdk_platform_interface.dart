import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'zoom_meeting_flutter_sdk_method_channel.dart';

abstract class ZoomMeetingFlutterSdkPlatform extends PlatformInterface {
  /// Constructs a ZoomMeetingFlutterSdkPlatform.
  ZoomMeetingFlutterSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static ZoomMeetingFlutterSdkPlatform _instance = MethodChannelZoomMeetingFlutterSdk();

  /// The default instance of [ZoomMeetingFlutterSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelZoomMeetingFlutterSdk].
  static ZoomMeetingFlutterSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ZoomMeetingFlutterSdkPlatform] when
  /// they register themselves.
  static set instance(ZoomMeetingFlutterSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> initZoom({
    required String jwtToken,
  }) {
    throw UnimplementedError('initZoom() has not been implemented.');
  }

  Future<bool?> joinMeting({
    required String meetingNumber,
    required String meetingPassword,
    required String displayName,
  }) {
    throw UnimplementedError('joinMeting() has not been implemented.');
  }
}
