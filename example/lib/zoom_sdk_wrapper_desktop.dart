import 'package:flutter/foundation.dart';
import 'zoom_desktop/zm_desktop.dart';
import 'zoom_sdk_wrapper.dart';

class ZoomSDKWrapperDesktop extends ZoomSDKWrapper {
  final ZoomMeetingDesktop _zoomSDK = ZoomMeetingDesktop();

  @override
  Future<bool?> initZoom({required String jwtToken}) {
    debugPrint("Desktop wrapper-initZoom");
    return _zoomSDK.initZoom(jwtToken: jwtToken);
  }

  @override
  Future<bool?> joinMeting({
    required String meetingNumber, 
    required String meetingPassword,
    required String displayName
  }) {
    debugPrint("Desktop wrapper-joinMeting $meetingNumber");
    return _zoomSDK.joinMeting(meetingNumber: meetingNumber, meetingPassword: meetingPassword, displayName: displayName);

  }
}
