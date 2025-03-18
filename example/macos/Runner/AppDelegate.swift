import Cocoa
import FlutterMacOS

// #include <ZoomSDK.h>
import ZoomSDK

@main
class AppDelegate: FlutterAppDelegate {
  let sdk = ZoomSDK.shared();

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    // NSLog("Swift: Application should terminate after last window closed")
    return true
  }

  override func applicationDidFinishLaunching(_ notification: Notification) {
    // NSLog("Swift: Application did finish launching")
    let controller: FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "zoom_meeting_flutter_sdk_macos", binaryMessenger: controller.engine.binaryMessenger)
    
    channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      guard let self = self else { return }
      switch call.method {
      case "initZoom":
        self.initializeSDK( result: result);
      case "authSdk":
        if let args = call.arguments as? [String: Any],
           let jwtToken = args["jwtToken"] as? String {
          self.auth(jwtToken: jwtToken, result: result);
        } else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Meeting details required", details: nil))
        }
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
    let initParams = ZoomSDKInitParams()
    initParams.enableLog = true // Optional for debugging
    initParams.zoomDomain = "zoom.us"
    let initResult = sdk.initSDK(with: initParams)

    let initSuccess = handleZoomSDKError("InitializeSDK", initResult);
    result(initSuccess)
  }

  private func auth(jwtToken: String, result: @escaping FlutterResult){
    let authService = sdk.getAuthService();
    let authContext = ZoomSDKAuthContext()
    NSLog("JWT Token: " + jwtToken);
    authContext.jwtToken = jwtToken // Input your JWT

    let authResult = authService.sdkAuth(authContext)
    // sdk.setZoomDomain("zoom.us")

    result(handleZoomSDKError("SdkAuth", authResult));
  }

  private func joinMeeting(meetingNumber: Int64, displayName: String, password: String, result: @escaping FlutterResult) {
    let meetingService = ZoomSDKMeetingService();
    let joinParam = ZoomSDKJoinMeetingElements()
    
    joinParam.meetingNumber = meetingNumber
    joinParam.password = password
    joinParam.displayName = displayName 
    joinParam.isNoAudio = true
    joinParam.isNoVideo = true
    
    let joinResult = meetingService.joinMeeting(joinParam);

    result(handleZoomSDKError("JoinMeeting", joinResult));
  }

  private func handleZoomSDKError(_ tags: String, _ error: ZoomSDKError) -> Bool {
    switch error {
      case ZoomSDKError_Success:
        NSLog(tags + " Successfully")
        return true
      case ZoomSDKError_Failed:
        // NSLog(FlutterError(code: "INIT_FAILED", message: "SDK initialization failed", details: nil))
        NSLog(">>>" + tags + " INIT_FAILED")
        return false
      case ZoomSDKError_Uninit:
        // NSLog(FlutterError(code: "UNINIT", message: "SDK is not initialized", details: nil))
        NSLog(">>>" + tags + " UNINIT")
        return false
      case ZoomSDKError_ServiceFailed:
        // NSLog(FlutterError(code: "SERVICE_FAILED", message: "Service failed", details: nil))
        NSLog(">>>" + tags + " SERVICE_FAILED")
        return false
      case ZoomSDKError_WrongUsage:
        // NSLog(FlutterError(code: "WRONG_USAGE", message: "Incorrect usage of the feature", details: nil))
        NSLog(">>>" + tags + " WRONG_USAGE")
        return false
      case ZoomSDKError_InvalidParameter:
        // NSLog(FlutterError(code: "INVALID_PARAMETER", message: "Wrong parameter", details: nil))
        NSLog(">>>" + tags + " INVALID_PARAMETER")
        return false
      case ZoomSDKError_NoPermission:
        // NSLog(FlutterError(code: "NO_PERMISSION", message: "No permission", details: nil))
        NSLog(">>>" + tags + " NO_PERMISSION")
        return false
      case ZoomSDKError_NoRecordingInProgress:
        // NSLog(FlutterError(code: "NO_RECORDING_IN_PROGRESS", message: "There is no recording in process", details: nil))
        NSLog(">>>" + tags + " NO_RECORDING_IN_PROGRESS")
        return false
      case ZoomSDKError_TooFrequentCall:
        // NSLog(FlutterError(code: "TOO_FREQUENT_CALL", message: "API calls are too frequent", details: nil))
        NSLog(">>>" + tags + " TOO_FREQUENT_CALL")
        return false
      case ZoomSDKError_UnSupportedFeature:
        // NSLog(FlutterError(code: "UNSUPPORTED_FEATURE", message: "Unsupported feature", details: nil))
        NSLog(">>>" + tags + " UNSUPPORTED_FEATURE")
        return false
      case ZoomSDKError_EmailLoginIsDisabled:
        // NSLog(FlutterError(code: "EMAIL_LOGIN_DISABLED", message: "Email login is disabled", details: nil))
        NSLog(">>>" + tags + " EMAIL_LOGIN_DISABLED")
        return false
      case ZoomSDKError_ModuleLoadFail:
        // NSLog(FlutterError(code: "MODULE_LOAD_FAIL", message: "Module load failed", details: nil))
        NSLog(">>>" + tags + " MODULE_LOAD_FAIL")
        return false
      case ZoomSDKError_NoVideoData:
        // NSLog(FlutterError(code: "NO_VIDEO_DATA", message: "No video data", details: nil))
        NSLog(">>>" + tags + " NO_VIDEO_DATA")
        return false
      case ZoomSDKError_NoAudioData:
        // NSLog(FlutterError(code: "NO_AUDIO_DATA", message: "No audio data", details: nil))
        NSLog(">>>" + tags + " NO_AUDIO_DATA")
        return false
      case ZoomSDKError_NoShareData:
        // NSLog(FlutterError(code: "NO_SHARE_DATA", message: "No share data", details: nil))
        NSLog(">>>" + tags + " NO_SHARE_DATA")
        return false
      case ZoomSDKError_NoVideoDeviceFound:
        // NSLog(FlutterError(code: "NO_VIDEO_DEVICE_FOUND", message: "No video device found", details: nil))
        NSLog(">>>" + tags + " NO_VIDEO_DEVICE_FOUND")
        return false
      case ZoomSDKError_DeviceError:
        // NSLog(FlutterError(code: "DEVICE_ERROR", message: "Device error", details: nil))
        NSLog(">>>" + tags + " DEVICE_ERROR")
        return false
      case ZoomSDKError_NotInMeeting:
        // NSLog(FlutterError(code: "NOT_IN_MEETING", message: "Not in meeting", details: nil))
        NSLog(">>>" + tags + " NOT_IN_MEETING")
        return false
      case ZoomSDKError_initDevice:
        // NSLog(FlutterError(code: "INIT_DEVICE", message: "Init device error", details: nil))
        NSLog(">>>" + tags + " INIT_DEVICE")
        return false
      case ZoomSDKError_CanNotChangeVirtualDevice:
        // NSLog(FlutterError(code: "CANNOT_CHANGE_VIRTUAL_DEVICE", message: "Can't change virtual device", details: nil))
        NSLog(">>>" + tags + " CANNOT_CHANGE_VIRTUAL_DEVICE")
        return false
      case ZoomSDKError_PreprocessRawdataError:
        // NSLog(FlutterError(code: "PREPROCESS_RAWDATA_ERROR", message: "Preprocess rawdata error", details: nil))
        NSLog(">>>" + tags + " PREPROCESS_RAWDATA_ERROR")
        return false
      case ZoomSDKError_NoLicense:
        // NSLog(FlutterError(code: "NO_LICENSE", message: "No license", details: nil))
        NSLog(">>>" + tags + " NO_LICENSE")
        return false
      case ZoomSDKError_Malloc_Failed:
        // NSLog(FlutterError(code: "MALLOC_FAILED", message: "Malloc failed", details: nil))
        NSLog(">>>" + tags + " MALLOC_FAILED")
        return false
      case ZoomSDKError_ShareCannotSubscribeMyself:
        // NSLog(FlutterError(code: "SHARE_CANNOT_SUBSCRIBE_MYSELF", message: "Share cannot subscribe myself", details: nil))
        NSLog(">>>" + tags + " SHARE_CANNOT_SUBSCRIBE_MYSELF")
        return false
      case ZoomSDKError_NeedUserConfirmRecordDisclaimer:
        // NSLog(FlutterError(code: "NEED_USER_CONFIRM_RECORD_DISCLAIMER", message: "Need user confirm record disclaimer", details: nil))
        NSLog(">>>" + tags + " NEED_USER_CONFIRM_RECORD_DISCLAIMER")
        return false
      case ZoomSDKError_UnKnown:
        // NSLog(FlutterError(code: "UNKNOWN", message: "Unknown error", details: nil))
        NSLog(">>>" + tags + " UNKNOWN")
        return false
      case ZoomSDKError_NotJoinAudio:
        // NSLog(FlutterError(code: "NOT_JOIN_AUDIO", message: "Not join audio", details: nil))
        NSLog(">>>" + tags + " NOT_JOIN_AUDIO")
        return false
      case ZoomSDKError_HardwareDontSupport:
        // NSLog(FlutterError(code: "HARDWARE_DONT_SUPPORT", message: "The current device doesn't support the feature", details: nil))
        NSLog(">>>" + tags + " HARDWARE_DONT_SUPPORT")
        return false
      case ZoomSDKError_DomainDontSupport:
        // NSLog(FlutterError(code: "DOMAIN_DONT_SUPPORT", message: "Domain not support", details: nil))
        NSLog(">>>" + tags + " DOMAIN_DONT_SUPPORT")
        return false
      case ZoomSDKError_FileTransferError:
        // NSLog(FlutterError(code: "FILE_TRANSFER_ERROR", message: "File transfer failed", details: nil))
        NSLog(">>>" + tags + " FILE_TRANSFER_ERROR")
        return false
      default:
        // NSLog(FlutterError(code: "INIT_FAILED", message: "ZoomSDKError failed with code: \(error.rawValue)", details: nil))
        NSLog(">>>" + tags + " INIT_FAILED")
        return false
    }
  }
}
