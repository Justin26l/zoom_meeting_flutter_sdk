import 'package:flutter/material.dart';

import 'zoom_meeting_flutter_sdk_platform_interface.dart';

class ZoomMeetingFlutterSdk {
  Future<bool?> initZoom({
    required String jwtToken,
  }) {
    debugPrint("ZoomNatively-initZoom");

    return ZoomMeetingFlutterSdkPlatform.instance.initZoom(
      jwtToken: jwtToken,
    );
  }

  Future<bool?> joinMeting({
    required String meetingNumber, 
    required String meetingPassword,
    required String displayName
  }) {
    debugPrint("ZoomNatively-joinMeting $meetingNumber");
    return ZoomMeetingFlutterSdkPlatform.instance.joinMeting(
      meetingNumber: meetingNumber,
      meetingPassword: meetingPassword,
      displayName: displayName,
    );
  }
}
