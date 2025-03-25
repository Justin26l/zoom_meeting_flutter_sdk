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
            }
        }
        NSLog("Swift : SDK Init ? \(self.sdkInitialized)")

        if self.sdkInitialized == true && sdkAuthSvc.isAuthorized() == false {
            let authParams = ZoomSDKAuthContext()
            NSLog(jwtToken)
            authParams.jwtToken = jwtToken
            let authResult = sdkAuthSvc.sdkAuth(authParams)
            let authSuccess = self.handleSdkErr("sdkAuth", authResult, result)

            NSLog("Swift : SDK Auth ? \(sdkAuthSvc.isAuthorized())")
            result(authSuccess)
        }
        else{
            result(false)
        }
    }

    private func joinMeeting(meetingNumber: Int64, displayName: String, password: String, result: @escaping FlutterResult) {

        // To Do
        let sdk = ZoomSDK.shared()
        guard let meetingService = sdk.getMeetingService() else {
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
        result(true)
    }

    private func handleSdkErr(_ tag: String, _ error: ZoomSDKError, _ result: @escaping FlutterResult) -> Bool {
        switch error {
        case ZoomSDKError_Success:
            NSLog("Swift : ZoomSDKError : " + tag + " - Success")
            return true

        case ZoomSDKError_Failed:
            result(FlutterError(code: "\(tag) INIT_FAILED", message: "SDK initialization failed", details: nil))
        case ZoomSDKError_Uninit:
            result(FlutterError(code: "\(tag) UNINIT", message: "SDK is not initialized", details: nil))
        case ZoomSDKError_ServiceFailed:
            result(FlutterError(code: "\(tag) SERVICE_FAILED", message: "Service failed", details: nil))
        case ZoomSDKError_WrongUsage:
            result(FlutterError(code: "\(tag) WRONG_USAGE", message: "Incorrect usage of the feature", details: nil))
        case ZoomSDKError_InvalidParameter:
            result(FlutterError(code: "\(tag) INVALID_PARAMETER", message: "Wrong parameter", details: nil))
        case ZoomSDKError_NoPermission:
            result(FlutterError(code: "\(tag) NO_PERMISSION", message: "No permission", details: nil))
        case ZoomSDKError_NoRecordingInProgress:
            result(FlutterError(code: "\(tag) NO_RECORDING_IN_PROGRESS", message: "There is no recording in process", details: nil))
        case ZoomSDKError_TooFrequentCall:
            result(FlutterError(code: "\(tag) TOO_FREQUENT_CALL", message: "API calls are too frequent", details: nil))
        case ZoomSDKError_UnSupportedFeature:
            result(FlutterError(code: "\(tag) UNSUPPORTED_FEATURE", message: "Unsupported feature", details: nil))
        case ZoomSDKError_EmailLoginIsDisabled:
            result(FlutterError(code: "\(tag) EMAIL_LOGIN_DISABLED", message: "Email login is disabled", details: nil))
        case ZoomSDKError_ModuleLoadFail:
            result(FlutterError(code: "\(tag) MODULE_LOAD_FAIL", message: "Module load failed", details: nil))
        case ZoomSDKError_NoVideoData:
            result(FlutterError(code: "\(tag) NO_VIDEO_DATA", message: "No video data", details: nil))
        case ZoomSDKError_NoAudioData:
            result(FlutterError(code: "\(tag) NO_AUDIO_DATA", message: "No audio data", details: nil))
        case ZoomSDKError_NoShareData:
            result(FlutterError(code: "\(tag) NO_SHARE_DATA", message: "No share data", details: nil))
        case ZoomSDKError_NoVideoDeviceFound:
            result(FlutterError(code: "\(tag) NO_VIDEO_DEVICE_FOUND", message: "No video device found", details: nil))
        case ZoomSDKError_DeviceError:
            result(FlutterError(code: "\(tag) DEVICE_ERROR", message: "Device error", details: nil))
        case ZoomSDKError_NotInMeeting:
            result(FlutterError(code: "\(tag) NOT_IN_MEETING", message: "Not in meeting", details: nil))
        case ZoomSDKError_initDevice:
            result(FlutterError(code: "\(tag) INIT_DEVICE", message: "Init device error", details: nil))
        case ZoomSDKError_CanNotChangeVirtualDevice:
            result(FlutterError(code: "\(tag) CANNOT_CHANGE_VIRTUAL_DEVICE", message: "Can't change virtual device", details: nil))
        case ZoomSDKError_PreprocessRawdataError:
            result(FlutterError(code: "\(tag) PREPROCESS_RAWDATA_ERROR", message: "Preprocess rawdata error", details: nil))
        case ZoomSDKError_NoLicense:
            result(FlutterError(code: "\(tag) NO_LICENSE", message: "No license", details: nil))
        case ZoomSDKError_Malloc_Failed:
            result(FlutterError(code: "\(tag) MALLOC_FAILED", message: "Malloc failed", details: nil))
        case ZoomSDKError_ShareCannotSubscribeMyself:
            result(FlutterError(code: "\(tag) SHARE_CANNOT_SUBSCRIBE_MYSELF", message: "Share cannot subscribe myself", details: nil))
        case ZoomSDKError_NeedUserConfirmRecordDisclaimer:
            result(FlutterError(code: "\(tag) NEED_USER_CONFIRM_RECORD_DISCLAIMER", message: "Need user confirm record disclaimer", details: nil))
        case ZoomSDKError_UnKnown:
            result(FlutterError(code: "\(tag) UNKNOWN", message: "Unknown error", details: nil))
        case ZoomSDKError_NotJoinAudio:
            result(FlutterError(code: "\(tag) NOT_JOIN_AUDIO", message: "Not join audio", details: nil))
        case ZoomSDKError_HardwareDontSupport:
            result(FlutterError(code: "\(tag) HARDWARE_DONT_SUPPORT", message: "The current device doesn't support the feature", details: nil))
        case ZoomSDKError_DomainDontSupport:
            result(FlutterError(code: "\(tag) DOMAIN_DONT_SUPPORT", message: "Domain not support", details: nil))
        case ZoomSDKError_FileTransferError:
            result(FlutterError(code: "\(tag) FILE_TRANSFER_ERROR", message: "File transfer failed", details: nil))
        default:
            result(FlutterError(code: "\(tag) SDK_Error", message: "SDK initialization failed with code: \(error.rawValue)", details: nil))
        }
        return false
    }

}
