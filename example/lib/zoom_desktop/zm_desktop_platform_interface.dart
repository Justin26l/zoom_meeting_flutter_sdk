import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'zm_desktop_method_channel.dart';

abstract class ZoomMeetingDesktopPlatform extends PlatformInterface {
  /// Constructs a ZoomMeetingDesktopPlatform.
  ZoomMeetingDesktopPlatform() : super(token: _token);

  static final Object _token = Object();

  static ZoomMeetingDesktopPlatform _instance = MethodChannelZoomMeetingDesktop();

  /// The default instance of [ZoomMeetingDesktopPlatform] to use.
  ///
  /// Defaults to [MethodChannelZoomMeetingDesktop].
  static ZoomMeetingDesktopPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ZoomMeetingDesktopPlatform] when
  /// they register themselves.
  static set instance(ZoomMeetingDesktopPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> initZoom() {
    throw UnimplementedError('initZoom() has not been implemented.');
  }
  Future<bool?> sdkAuth({
    required String jwtToken,
  }) {
    throw UnimplementedError('sdkAuth() has not been implemented.');
  }

  Future<bool?> joinMeting({
    required String meetingNumber,
    required String meetingPassword,
    required String displayName,
  }) {
    throw UnimplementedError('joinMeting() has not been implemented.');
  }
}
