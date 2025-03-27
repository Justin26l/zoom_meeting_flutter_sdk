import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:zoom_meeting_flutter_sdk/zoom_meeting_flutter_sdk.dart';
import 'zoom_sdk_wrapper_desktop.dart';

abstract class ZoomSDKWrapper implements ZoomMeetingFlutterSdk {
  @override
  Future<bool?> initZoom({required String jwtToken});
  
  @override
  Future<bool?> joinMeting({required String meetingNumber, required String meetingPassword, required String displayName});
}

class ZoomSDKWrapperImpl extends ZoomMeetingFlutterSdk {
  final _zoomSDK = Platform.isMacOS || Platform.isWindows ? ZoomSDKWrapperDesktop() : ZoomMeetingFlutterSdk();


  @override
  Future<bool?> initZoom({required String jwtToken}) {
    debugPrint(Platform.isMacOS ? "MacOS" : Platform.isWindows ? "Windows" : "Mobile");
    return _zoomSDK.initZoom(jwtToken: jwtToken);
  }

  @override
  Future<bool?> joinMeting({required String meetingNumber, required String meetingPassword, required String displayName}) {
    return _zoomSDK.joinMeting(meetingNumber: meetingNumber, meetingPassword: meetingPassword, displayName: displayName);
  }
}
