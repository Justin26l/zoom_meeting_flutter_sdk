import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'zm_desktop_platform_interface.dart';

/// An implementation of [ZoomMeetingDesktopPlatform] that uses method channels.
class MethodChannelZoomMeetingDesktop extends ZoomMeetingDesktopPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('zoom_meeting_flutter_sdk');

  @override
  Future<bool?> initZoom({
    required String jwtToken
  }) async {
    debugPrint("Desktop-initZoom");

    final version = await methodChannel.invokeMethod<bool>(
      'initZoom',
      {
        "jwtToken": jwtToken,
      },
    );
    return version;
  }

  @override
  Future<bool?> joinMeting({
    required String meetingNumber,
    required String meetingPassword,
    required String displayName,
  }) async {
    var meetingNumberInt = int.tryParse(meetingNumber);
    debugPrint("Desktop-joinMeting -> $meetingNumber, $meetingPassword, $displayName");
    final version = await methodChannel.invokeMethod<bool>(
      'joinMeeting',
      {
        "meetingNumber": meetingNumberInt,
        "password": meetingPassword,
        "displayName": displayName
      },
    );
    debugPrint("MethodChannelZoomNatively-joinMeting -> $version");
    return version;
  }
  
}
