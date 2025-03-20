import Cocoa
import FlutterMacOS

public class ZoomMeetingFlutterSdkMacosPluginA: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "zoom_meeting_flutter_sdk", binaryMessenger: registrar.messenger)
    let instance = ZoomMeetingFlutterSdkMacosPluginA()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
