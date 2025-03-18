import 'dart:async';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:zoom_meeting_flutter_sdk/zoom_meeting_flutter_sdk.dart';
import 'ZoomPlatformInterface.dart';

class ZoomMobileImplementation implements ZoomPlatformInterface {
  final _zoomSdk = ZoomMeetingFlutterSdk();

  @override
  Future<bool?> initZoom({required String jwtToken}) async {
    debugPrint("ZoomMobileImplementation-initZoom");
    try {
      return await _zoomSdk.initZoom(jwtToken: jwtToken);
    } catch (e) {
      debugPrint('Error initializing Zoom on mobile: $e');
      return false;
    }
  }

  @override
  Future<bool?> joinMeeting({
    required Int64 meetingNumber,
    required String meetingPassword,
    required String displayName
  }) async {
    debugPrint("ZoomMobileImplementation-joinMeeting $meetingNumber");
    // try {
      return await _zoomSdk.joinMeting(
        meetingNumber: meetingNumber.toString(),
        meetingPassword: meetingPassword,
        displayName: displayName
      );
    // } catch (e) {
    //   debugPrint('Error joining meeting on mobile: $e');
    //   return false;
    // }
  }
}