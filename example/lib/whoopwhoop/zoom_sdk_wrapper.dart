import 'dart:io' show Platform;
import 'ZoomPlatformInterface.dart';
import 'ZoomMobileImplementation.dart';
import 'ZoomMacOSImplementation.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';

class ZoomSDKWrapper implements ZoomPlatformInterface {
  static final ZoomSDKWrapper _instance = ZoomSDKWrapper._internal();
  
  factory ZoomSDKWrapper() => _instance;
  
  ZoomSDKWrapper._internal();
  
  final ZoomPlatformInterface _platformImplementation = _getPlatformImplementation();
  
  static ZoomPlatformInterface _getPlatformImplementation() {
    if (Platform.isMacOS) {
      debugPrint("ZoomSDKWrapper -> MacOS");
      return ZoomMacOSImplementation();
    } else {
      debugPrint("ZoomSDKWrapper -> MacOS");
      // For iOS and Android
      return ZoomMobileImplementation();
    }
  }

  @override
  Future<bool?> initZoom({required String jwtToken}) {
    debugPrint("ZoomSDKWrapper -> initZoom");
    return _platformImplementation.initZoom(jwtToken: jwtToken);
  }

  @override
  Future<bool?> joinMeeting({
    required Int64 meetingNumber, 
    required String meetingPassword, 
    required String displayName
  }) {
    debugPrint("ZoomSDKWrapper -> joinMeeting");
    return _platformImplementation.joinMeeting(
      meetingNumber: meetingNumber,
      meetingPassword: meetingPassword,
      displayName: displayName
    );
  }
}