import 'package:flutter/material.dart';

import 'zm_desktop_platform_interface.dart';

class ZoomMeetingDesktop {
  var isZoomInitialized = false;
  var isZoomAuth = false;

  Future<bool?> initZoom({
    required String jwtToken,
  }) async {
    debugPrint("dart : ZoomMeetingDesktop: initZoom()");

    if (!isZoomInitialized) {
      var initResult = await ZoomMeetingDesktopPlatform.instance.initZoom();
      isZoomInitialized = initResult ?? false;
      return initResult;
    }
    else if (!isZoomAuth) {
      var authResult = await ZoomMeetingDesktopPlatform.instance.sdkAuth(
        jwtToken: jwtToken,
      );
      isZoomAuth = authResult ?? false;
      return authResult;
    }
    else {
      debugPrint("dart : ZoomMeetingDesktop: Zoom already initialized and authenticated");
      return true;
    }
  }

  Future<bool?> sdkAuth({
    required String jwtToken,
  }) {
    debugPrint("Desktop sdkAuth");

    return ZoomMeetingDesktopPlatform.instance.sdkAuth(
      jwtToken: jwtToken,
    );
  }

  Future<bool?> joinMeting(
  {
    required String meetingNumber, 
    required String meetingPassword,
    required String displayName
  }) {
    debugPrint("Desktop joinMeting $meetingNumber");
    return ZoomMeetingDesktopPlatform.instance.joinMeting(
      meetingNumber: meetingNumber,
      meetingPassword: meetingPassword,
      displayName: displayName,
    );
  }
}
