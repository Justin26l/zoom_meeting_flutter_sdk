import 'dart:async';
import 'package:fixnum/fixnum.dart';

abstract class ZoomPlatformInterface {
  Future<bool?> initZoom({required String jwtToken});
  Future<bool?> joinMeeting({
    required Int64 meetingNumber,
    required String meetingPassword,
    required String displayName
  });
}