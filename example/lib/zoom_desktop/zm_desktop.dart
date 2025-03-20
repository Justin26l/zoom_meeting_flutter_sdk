import 'package:flutter/material.dart';

import 'zm_desktop_platform_interface.dart';

class ZoomMeetingDesktop {
  Future<bool?> initZoom({
    required String jwtToken,
  }) {
    debugPrint("ZoomNatively-initZoom");

    return ZoomMeetingDesktopPlatform.instance.initZoom(
      jwtToken: jwtToken,
    );
  }

  Future<bool?> joinMeting(
  {
    required String meetingNumber, 
    required String meetingPassword,
    required String displayName
  }) {
    debugPrint("ZoomNatively-joinMeting $meetingNumber");
    return ZoomMeetingDesktopPlatform.instance.joinMeting(
      meetingNumber: meetingNumber,
      meetingPassword: meetingPassword,
      displayName: displayName,
    );
  }
}
