#import "ZoomMeetingFlutterSdkMacosPlugin.h"
#if __has_include(<zoom_meeting_flutter_sdk/zoom_meeting_flutter_sdk-Swift.h>)
#import <zoom_meeting_flutter_sdk/zoom_meeting_flutter_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "zoom_meeting_flutter_sdk-Swift.h"
#endif

@implementation ZoomMeetingFlutterSdkMacosPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftZoomMeetingFlutterSdkMacosPlugin registerWithRegistrar:registrar];
}
@end
