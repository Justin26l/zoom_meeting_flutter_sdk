import Cocoa
import FlutterMacOS
import ZoomSDK
// #include <ZoomSDK.h>

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    NSLog("Swift: Application should terminate after last window closed")
    return true
  }

  override func applicationDidFinishLaunching(_ notification: Notification) {
    NSLog("Swift: Application did finish launching")
    let controller: FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "zoom_meeting_flutter_sdk_macos", binaryMessenger: controller.engine.binaryMessenger)
    
    channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      guard let self = self else { return }
      switch call.method {
      case "initZoom":
        self.initializeSDK(result: result)
      case "joinMeeting":
        if let args = call.arguments as? [String: Any],
           let meetingNumber = args["meetingNumber"] as? Int64,
           let displayName = args["displayName"] as? String,
           let password = args["password"] as? String {
          self.joinMeeting(meetingNumber: meetingNumber, displayName: displayName, password: password, result: result)
        } else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Meeting details required", details: nil))
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    
    super.applicationDidFinishLaunching(notification)
  }

  private func initializeSDK(result: @escaping FlutterResult) {
    let sdk = ZoomSDK.shared()
    
    let initParams = ZoomSDKInitParams()
    initParams.zoomDomain = "zoom.us"
    initParams.enableLog = true
    // initParams.jwtToken = jwtToken
    
    let initResult = sdk.initSDK(with: initParams)
       

    switch initResult {
    case ZoomSDKError_Success:
        NSLog("SDK initialized successfully")
        result(true)
    case ZoomSDKError_Failed:
        result(FlutterError(code: "INIT_FAILED", message: "SDK initialization failed", details: nil))
    case ZoomSDKError_Uninit:
        result(FlutterError(code: "UNINIT", message: "SDK is not initialized", details: nil))
    case ZoomSDKError_ServiceFailed:
        result(FlutterError(code: "SERVICE_FAILED", message: "Service failed", details: nil))
    case ZoomSDKError_WrongUsage:
        result(FlutterError(code: "WRONG_USAGE", message: "Incorrect usage of the feature", details: nil))
    case ZoomSDKError_InvalidParameter:
        result(FlutterError(code: "INVALID_PARAMETER", message: "Wrong parameter", details: nil))
    case ZoomSDKError_NoPermission:
        result(FlutterError(code: "NO_PERMISSION", message: "No permission", details: nil))
    case ZoomSDKError_NoRecordingInProgress:
        result(FlutterError(code: "NO_RECORDING_IN_PROGRESS", message: "There is no recording in process", details: nil))
    case ZoomSDKError_TooFrequentCall:
        result(FlutterError(code: "TOO_FREQUENT_CALL", message: "API calls are too frequent", details: nil))
    case ZoomSDKError_UnSupportedFeature:
        result(FlutterError(code: "UNSUPPORTED_FEATURE", message: "Unsupported feature", details: nil))
    case ZoomSDKError_EmailLoginIsDisabled:
        result(FlutterError(code: "EMAIL_LOGIN_DISABLED", message: "Email login is disabled", details: nil))
    case ZoomSDKError_ModuleLoadFail:
        result(FlutterError(code: "MODULE_LOAD_FAIL", message: "Module load failed", details: nil))
    case ZoomSDKError_NoVideoData:
        result(FlutterError(code: "NO_VIDEO_DATA", message: "No video data", details: nil))
    case ZoomSDKError_NoAudioData:
        result(FlutterError(code: "NO_AUDIO_DATA", message: "No audio data", details: nil))
    case ZoomSDKError_NoShareData:
        result(FlutterError(code: "NO_SHARE_DATA", message: "No share data", details: nil))
    case ZoomSDKError_NoVideoDeviceFound:
        result(FlutterError(code: "NO_VIDEO_DEVICE_FOUND", message: "No video device found", details: nil))
    case ZoomSDKError_DeviceError:
        result(FlutterError(code: "DEVICE_ERROR", message: "Device error", details: nil))
    case ZoomSDKError_NotInMeeting:
        result(FlutterError(code: "NOT_IN_MEETING", message: "Not in meeting", details: nil))
    case ZoomSDKError_initDevice:
        result(FlutterError(code: "INIT_DEVICE", message: "Init device error", details: nil))
    case ZoomSDKError_CanNotChangeVirtualDevice:
        result(FlutterError(code: "CANNOT_CHANGE_VIRTUAL_DEVICE", message: "Can't change virtual device", details: nil))
    case ZoomSDKError_PreprocessRawdataError:
        result(FlutterError(code: "PREPROCESS_RAWDATA_ERROR", message: "Preprocess rawdata error", details: nil))
    case ZoomSDKError_NoLicense:
        result(FlutterError(code: "NO_LICENSE", message: "No license", details: nil))
    case ZoomSDKError_Malloc_Failed:
        result(FlutterError(code: "MALLOC_FAILED", message: "Malloc failed", details: nil))
    case ZoomSDKError_ShareCannotSubscribeMyself:
        result(FlutterError(code: "SHARE_CANNOT_SUBSCRIBE_MYSELF", message: "Share cannot subscribe myself", details: nil))
    case ZoomSDKError_NeedUserConfirmRecordDisclaimer:
        result(FlutterError(code: "NEED_USER_CONFIRM_RECORD_DISCLAIMER", message: "Need user confirm record disclaimer", details: nil))
    case ZoomSDKError_UnKnown:
        result(FlutterError(code: "UNKNOWN", message: "Unknown error", details: nil))
    case ZoomSDKError_NotJoinAudio:
        result(FlutterError(code: "NOT_JOIN_AUDIO", message: "Not join audio", details: nil))
    case ZoomSDKError_HardwareDontSupport:
        result(FlutterError(code: "HARDWARE_DONT_SUPPORT", message: "The current device doesn't support the feature", details: nil))
    case ZoomSDKError_DomainDontSupport:
        result(FlutterError(code: "DOMAIN_DONT_SUPPORT", message: "Domain not support", details: nil))
    case ZoomSDKError_FileTransferError:
        result(FlutterError(code: "FILE_TRANSFER_ERROR", message: "File transfer failed", details: nil))
    default:
        result(FlutterError(code: "INIT_FAILED", message: "SDK initialization failed with code: \(initResult.rawValue)", details: nil))
    }

  }

  private func joinMeeting(meetingNumber: Int64, displayName: String, password: String, result: @escaping FlutterResult) {
    guard let meetingService = ZoomSDK.shared().getMeetingService() else {
      result(FlutterError(code: "SERVICE_UNAVAILABLE", message: "Failed to get meeting service", details: nil))
      return
    }
    
    let joinParam = ZoomSDKJoinMeetingElements()
    joinParam.displayName = displayName 
    joinParam.meetingNumber = meetingNumber
    joinParam.isNoAudio = true
    joinParam.isNoVideo = true
    joinParam.password = password
    
    meetingService.joinMeeting(joinParam)
  }
}
