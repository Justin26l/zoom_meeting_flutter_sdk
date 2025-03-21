import 'package:zoom_meeting_flutter_sdk_example/zoom_desktop/zm_desktop.dart';
import 'zoom_sdk_wrapper.dart';

class ZoomSDKWrapperDesktop extends ZoomSDKWrapper {
  final ZoomMeetingDesktop _zoomSDK = ZoomMeetingDesktop();

  @override
  Future<bool?> initZoom({required String jwtToken}) {
    return _zoomSDK.initZoom(jwtToken: jwtToken);
  }

  @override
  Future<bool?> joinMeting({
    required String meetingNumber, 
    required String meetingPassword,
    required String displayName
  }) {
    return _zoomSDK.joinMeting(meetingNumber: meetingNumber, meetingPassword: meetingPassword, displayName: displayName);
  }
}
