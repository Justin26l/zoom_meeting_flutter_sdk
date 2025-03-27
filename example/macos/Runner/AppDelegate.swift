import Cocoa
import FlutterMacOS
import ZoomSDK

@main
class AppDelegate: FlutterAppDelegate {

    var sdkInitialized = false
    
    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    override func applicationDidFinishLaunching(_ notification: Notification) {
        NSLog("Swift: Application did finish launching")
        let controller: FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "zoom_meeting_flutter_sdk", binaryMessenger: controller.engine.binaryMessenger)
        
        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let self = self else { return }
            switch call.method {
                case "initZoom":
                    if let args = call.arguments as? [String: Any],
                        let jwtToken = args["jwtToken"] as? String {
                        self.initializeSDK(jwtToken: jwtToken, result: result)
                    } else {
                        result(FlutterError(code: "INVALID_ARGUMENTS", message: "", details: nil))
                    }
                case "joinMeeting":
                    if let args = call.arguments as? [String: Any],
                        let meetingNumber = args["meetingNumber"] as? Int64,
                        let displayName = args["displayName"] as? String,
                        let password = args["password"] as? String 
                        {
                            self.joinMeeting(meetingNumber: meetingNumber, displayName: displayName, password: password, result: result)
                        } else {
                            result(FlutterError(code: "INVALID_ARGUMENTS", message: "", details: nil))
                        }
                default:
                    result("Fucker, method not implemented on swift side")
            }
        }
        
        super.applicationDidFinishLaunching(notification)
    }

    private func initializeSDK(jwtToken: String, result: @escaping FlutterResult) {
        NSLog("init SDK")
        let sdk = ZoomSDK.shared()
        let sdkAuthSvc = sdk.getAuthService()
        // var sdkInitializedSuccessfully = false

        if self.sdkInitialized == false {
            let initParams = ZoomSDKInitParams()
            initParams.zoomDomain = "zoom.us"
            initParams.enableLog = true
            let initResult = sdk.initSDK(with: initParams)
            let initSuccess = self.handleSdkErr("initSDK", initResult, result)
            if initSuccess == true {
                self.sdkInitialized = true
                NSLog("Swift : sdkInitialized = \(self.sdkInitialized)")
                self.authenticateSDK(sdk: sdk, jwtToken: jwtToken, result: result)

            }
        }
        else if sdkAuthSvc.isAuthorized() == false {
            self.authenticateSDK(sdk: sdk, jwtToken: jwtToken, result: result)
        }
        else{
            result(true)
        }
    }

    private func authenticateSDK(sdk: ZoomSDK, jwtToken: String, result: @escaping FlutterResult) {
        let sdkAuthSvc = sdk.getAuthService()
        let authParams = ZoomSDKAuthContext()
        NSLog(jwtToken)
        authParams.jwtToken = jwtToken
        let authResult = sdkAuthSvc.sdkAuth(authParams)
        let authSuccess = self.handleSdkErr("sdkAuth", authResult, result)
        
        NSLog("Swift : sdkAuthSvc.isAuthorized() = \(sdkAuthSvc.isAuthorized())")
        result(authSuccess)
    }

    private func joinMeeting(meetingNumber: Int64, displayName: String, password: String, result: @escaping FlutterResult) {

        // To Do
        let sdk = ZoomSDK.shared()
        let sdkMeetSvc = sdk.getMeetingService()
        
        let joinParam = ZoomSDKJoinMeetingElements()
        joinParam.displayName = displayName 
        joinParam.meetingNumber = meetingNumber
        joinParam.isNoAudio = true
        joinParam.isNoVideo = true
        joinParam.password = password
        
        sdkMeetSvc?.joinMeeting(joinParam)
        result(true)
    }

    private func handleSdkErr(_ tag: String, _ error: ZoomSDKError, _ result: @escaping FlutterResult) -> Bool {
        switch error {
        case ZoomSDKError_Success:
            NSLog("Swift :  \(tag) - Success")
            return true

        case ZoomSDKError_Failed:
            result(FlutterError(code: "Swift : \(tag), FAILED", message: "ZoomSDKError_Failed", details: nil))
        case ZoomSDKError_Uninit:
            result(FlutterError(code: "Swift : \(tag), UNINIT", message: "ZoomSDKError_Uninit", details: nil))
        case ZoomSDKError_ServiceFailed:
            result(FlutterError(code: "Swift : \(tag), SERVICE_FAILED", message: "ZoomSDKError_ServiceFailed", details: nil))
        case ZoomSDKError_WrongUsage:
            result(FlutterError(code: "Swift : \(tag), WRONG_USAGE", message: " of the featureZoomSDKError_WrongUsage", details: nil))
        case ZoomSDKError_InvalidParameter:
            result(FlutterError(code: "Swift : \(tag), INVALID_PARAMETER", message: "ZoomSDKError_InvalidParameter", details: nil))
        case ZoomSDKError_NoPermission:
            result(FlutterError(code: "Swift : \(tag), NO_PERMISSION", message: "ZoomSDKError_NoPermission", details: nil))
        case ZoomSDKError_NoRecordingInProgress:
            result(FlutterError(code: "Swift : \(tag), NO_RECORDING_IN_PROGRESS", message: " no recording in processZoomSDKError_NoRecordingInProgress", details: nil))
        case ZoomSDKError_TooFrequentCall:
            result(FlutterError(code: "Swift : \(tag), TOO_FREQUENT_CALL", message: " are too frequentZoomSDKError_TooFrequentCall", details: nil))
        case ZoomSDKError_UnSupportedFeature:
            result(FlutterError(code: "Swift : \(tag), UNSUPPORTED_FEATURE", message: "ZoomSDKError_UnSupportedFeature", details: nil))
        case ZoomSDKError_EmailLoginIsDisabled:
            result(FlutterError(code: "Swift : \(tag), EMAIL_LOGIN_DISABLED", message: " is disabledZoomSDKError_EmailLoginIsDisabled", details: nil))
        case ZoomSDKError_ModuleLoadFail:
            result(FlutterError(code: "Swift : \(tag), MODULE_LOAD_FAIL", message: " failedZoomSDKError_ModuleLoadFail", details: nil))
        case ZoomSDKError_NoVideoData:
            result(FlutterError(code: "Swift : \(tag), NO_VIDEO_DATA", message: " dataZoomSDKError_NoVideoData", details: nil))
        case ZoomSDKError_NoAudioData:
            result(FlutterError(code: "Swift : \(tag), NO_AUDIO_DATA", message: " dataZoomSDKError_NoAudioData", details: nil))
        case ZoomSDKError_NoShareData:
            result(FlutterError(code: "Swift : \(tag), NO_SHARE_DATA", message: " dataZoomSDKError_NoShareData", details: nil))
        case ZoomSDKError_NoVideoDeviceFound:
            result(FlutterError(code: "Swift : \(tag), NO_VIDEO_DEVICE_FOUND", message: " device foundZoomSDKError_NoVideoDeviceFound", details: nil))
        case ZoomSDKError_DeviceError:
            result(FlutterError(code: "Swift : \(tag), DEVICE_ERROR", message: "ZoomSDKError_DeviceError", details: nil))
        case ZoomSDKError_NotInMeeting:
            result(FlutterError(code: "Swift : \(tag), NOT_IN_MEETING", message: " meetingZoomSDKError_NotInMeeting", details: nil))
        case ZoomSDKError_initDevice:
            result(FlutterError(code: "Swift : \(tag), INIT_DEVICE", message: " errorZoomSDKError_initDevice", details: nil))
        case ZoomSDKError_CanNotChangeVirtualDevice:
            result(FlutterError(code: "Swift : \(tag), CANNOT_CHANGE_VIRTUAL_DEVICE", message: " change virtual deviceZoomSDKError_CanNotChangeVirtualDevice", details: nil))
        case ZoomSDKError_PreprocessRawdataError:
            result(FlutterError(code: "Swift : \(tag), PREPROCESS_RAWDATA_ERROR", message: " errorZoomSDKError_PreprocessRawdataError", details: nil))
        case ZoomSDKError_NoLicense:
            result(FlutterError(code: "Swift : \(tag), NO_LICENSE", message: "ZoomSDKError_NoLicense", details: nil))
        case ZoomSDKError_Malloc_Failed:
            result(FlutterError(code: "Swift : \(tag), MALLOC_FAILED", message: "ZoomSDKError_Malloc_Failed", details: nil))
        case ZoomSDKError_ShareCannotSubscribeMyself:
            result(FlutterError(code: "Swift : \(tag), SHARE_CANNOT_SUBSCRIBE_MYSELF", message: " subscribe myselfZoomSDKError_ShareCannotSubscribeMyself", details: nil))
        case ZoomSDKError_NeedUserConfirmRecordDisclaimer:
            result(FlutterError(code: "Swift : \(tag), NEED_USER_CONFIRM_RECORD_DISCLAIMER", message: " confirm record disclaimerZoomSDKError_NeedUserConfirmRecordDisclaimer", details: nil))
        case ZoomSDKError_UnKnown:
            result(FlutterError(code: "Swift : \(tag), UNKNOWN", message: "ZoomSDKError_UnKnown", details: nil))
        case ZoomSDKError_NotJoinAudio:
            result(FlutterError(code: "Swift : \(tag), NOT_JOIN_AUDIO", message: " audioZoomSDKError_NotJoinAudio", details: nil))
        case ZoomSDKError_HardwareDontSupport:
            result(FlutterError(code: "Swift : \(tag), HARDWARE_DONT_SUPPORT", message: " device doesn't support the featureZoomSDKError_HardwareDontSupport", details: nil))
        case ZoomSDKError_DomainDontSupport:
            result(FlutterError(code: "Swift : \(tag), DOMAIN_DONT_SUPPORT", message: " supportZoomSDKError_DomainDontSupport", details: nil))
        case ZoomSDKError_FileTransferError:
            result(FlutterError(code: "Swift : \(tag), FILE_TRANSFER_ERROR", message: " failedZoomSDKError_FileTransferError", details: nil))
        default:
            result(FlutterError(code: "Swift : \(tag), SDK_Error", message: " failed with code: \(error.rawValue)lt", details: nil))
        }
        return false
    }

}
