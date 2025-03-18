import 'dart:async';

abstract class ZoomPlatformInterface {
  Future<bool?> initZoom({required String jwtToken});
  Future<bool?> joinMeeting({
    required int meetingNumber,
    required String meetingPassword,
    required String displayName
  });
}