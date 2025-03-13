import 'package:flutter_test/flutter_test.dart';
import 'package:zoom_meeting_flutter_sdk/zoom_meeting_flutter_sdk_platform_interface.dart';
import 'package:zoom_meeting_flutter_sdk/zoom_meeting_flutter_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockZoomMeetingFlutterSdkPlatform
    with MockPlatformInterfaceMixin
    implements ZoomMeetingFlutterSdkPlatform {


  @override
  Future<bool?> initZoom({required String jwtToken}) {
    throw UnimplementedError();
  }

  @override
  Future<bool?> joinMeting({required String meetingNumber, required String meetingPassword, required String displayName}) {
    throw UnimplementedError();
  }
}

void main() {
  final ZoomMeetingFlutterSdkPlatform initialPlatform = ZoomMeetingFlutterSdkPlatform.instance;

  test('$MethodChannelZoomMeetingFlutterSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelZoomMeetingFlutterSdk>());
  });

}
