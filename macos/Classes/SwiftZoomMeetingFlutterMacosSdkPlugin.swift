import Cocoa
import FlutterMacOS
// import ZoomSDK

public class SwiftZoomMeetingFlutterSdkMacosPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "zoom_meeting_flutter_sdk", binaryMessenger: registrar.messenger)
        let instance = SwiftZoomMeetingFlutterSdkMacosPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        NSLog("Swift: handle")

        switch call.method {
            case "getPlatformVersion":
                result("macOS " + ProcessInfo.processInfo.operatingSystemVersionString)
            case "initZoom":
                // self.initializeSDK(result: result)
                result(true)
            case "joinMeeting":
                // if let args = call.arguments as? [String: Any],
                //     let meetingNumber = args["meetingNumber"] as? Int64,
                //     let displayName = args["displayName"] as? String,
                //     let password = args["password"] as? String {
                //         self.joinMeeting(meetingNumber: meetingNumber, displayName: displayName, password: password, result: result)
                //     } 
                //     else {
                //         result(FlutterError(code: "INVALID_ARGUMENTS", message: "", details: nil))
                //     }
                result(true)
            default:
              result(FlutterMethodNotImplemented)
        }
    }
    
    // func getDeviceID() -> String {
    //     NSLog("Swift: getDeviceID")
    //     return UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    // }

    // func getRootController() -> UIViewController {
    //     NSLog("Swift: getRootController")
    //     let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first
    //     let topController = (keyWindow?.rootViewController)!
    //     return topController
    // }

    // private func initializeSDK(result: @escaping FlutterResult) {
    //     NSLog("init SDK")
    //     let sdk = ZoomSDK.shared()
    //     var sdkInitializedSuccessfully = false

    //     let initParams = ZoomSDKInitParams()
    //     initParams.zoomDomain = "zoom.us"
    //     initParams.enableLog = true
    //     // initParams.jwtToken = jwtToken
        
    //     let initResult = sdk.initSDK(with: initParams)

    //     switch initResult {
    //     case ZoomSDKError_Success:
    //         NSLog("SDK initialized successfully")
    //         let authorizationService = sdk.getAuthService() {
    //             authorizationService.delegate = self;
    //             authorizationService.jwtToken = jwtToken;
    //             authorizationService.sdkAuth();
    //         }
    //         result(true)
    //     case ZoomSDKError_Failed:
    //         result(FlutterError(code: "INIT_FAILED", message: "SDK initialization failed", details: nil))
    //     case ZoomSDKError_Uninit:
    //         result(FlutterError(code: "UNINIT", message: "SDK is not initialized", details: nil))
    //     case ZoomSDKError_ServiceFailed:
    //         result(FlutterError(code: "SERVICE_FAILED", message: "Service failed", details: nil))
    //     case ZoomSDKError_WrongUsage:
    //         result(FlutterError(code: "WRONG_USAGE", message: "Incorrect usage of the feature", details: nil))
    //     case ZoomSDKError_InvalidParameter:
    //         result(FlutterError(code: "INVALID_PARAMETER", message: "Wrong parameter", details: nil))
    //     case ZoomSDKError_NoPermission:
    //         result(FlutterError(code: "NO_PERMISSION", message: "No permission", details: nil))
    //     case ZoomSDKError_NoRecordingInProgress:
    //         result(FlutterError(code: "NO_RECORDING_IN_PROGRESS", message: "There is no recording in process", details: nil))
    //     case ZoomSDKError_TooFrequentCall:
    //         result(FlutterError(code: "TOO_FREQUENT_CALL", message: "API calls are too frequent", details: nil))
    //     case ZoomSDKError_UnSupportedFeature:
    //         result(FlutterError(code: "UNSUPPORTED_FEATURE", message: "Unsupported feature", details: nil))
    //     case ZoomSDKError_EmailLoginIsDisabled:
    //         result(FlutterError(code: "EMAIL_LOGIN_DISABLED", message: "Email login is disabled", details: nil))
    //     case ZoomSDKError_ModuleLoadFail:
    //         result(FlutterError(code: "MODULE_LOAD_FAIL", message: "Module load failed", details: nil))
    //     case ZoomSDKError_NoVideoData:
    //         result(FlutterError(code: "NO_VIDEO_DATA", message: "No video data", details: nil))
    //     case ZoomSDKError_NoAudioData:
    //         result(FlutterError(code: "NO_AUDIO_DATA", message: "No audio data", details: nil))
    //     case ZoomSDKError_NoShareData:
    //         result(FlutterError(code: "NO_SHARE_DATA", message: "No share data", details: nil))
    //     case ZoomSDKError_NoVideoDeviceFound:
    //         result(FlutterError(code: "NO_VIDEO_DEVICE_FOUND", message: "No video device found", details: nil))
    //     case ZoomSDKError_DeviceError:
    //         result(FlutterError(code: "DEVICE_ERROR", message: "Device error", details: nil))
    //     case ZoomSDKError_NotInMeeting:
    //         result(FlutterError(code: "NOT_IN_MEETING", message: "Not in meeting", details: nil))
    //     case ZoomSDKError_initDevice:
    //         result(FlutterError(code: "INIT_DEVICE", message: "Init device error", details: nil))
    //     case ZoomSDKError_CanNotChangeVirtualDevice:
    //         result(FlutterError(code: "CANNOT_CHANGE_VIRTUAL_DEVICE", message: "Can't change virtual device", details: nil))
    //     case ZoomSDKError_PreprocessRawdataError:
    //         result(FlutterError(code: "PREPROCESS_RAWDATA_ERROR", message: "Preprocess rawdata error", details: nil))
    //     case ZoomSDKError_NoLicense:
    //         result(FlutterError(code: "NO_LICENSE", message: "No license", details: nil))
    //     case ZoomSDKError_Malloc_Failed:
    //         result(FlutterError(code: "MALLOC_FAILED", message: "Malloc failed", details: nil))
    //     case ZoomSDKError_ShareCannotSubscribeMyself:
    //         result(FlutterError(code: "SHARE_CANNOT_SUBSCRIBE_MYSELF", message: "Share cannot subscribe myself", details: nil))
    //     case ZoomSDKError_NeedUserConfirmRecordDisclaimer:
    //         result(FlutterError(code: "NEED_USER_CONFIRM_RECORD_DISCLAIMER", message: "Need user confirm record disclaimer", details: nil))
    //     case ZoomSDKError_UnKnown:
    //         result(FlutterError(code: "UNKNOWN", message: "Unknown error", details: nil))
    //     case ZoomSDKError_NotJoinAudio:
    //         result(FlutterError(code: "NOT_JOIN_AUDIO", message: "Not join audio", details: nil))
    //     case ZoomSDKError_HardwareDontSupport:
    //         result(FlutterError(code: "HARDWARE_DONT_SUPPORT", message: "The current device doesn't support the feature", details: nil))
    //     case ZoomSDKError_DomainDontSupport:
    //         result(FlutterError(code: "DOMAIN_DONT_SUPPORT", message: "Domain not support", details: nil))
    //     case ZoomSDKError_FileTransferError:
    //         result(FlutterError(code: "FILE_TRANSFER_ERROR", message: "File transfer failed", details: nil))
    //     default:
    //         result(FlutterError(code: "INIT_FAILED", message: "SDK initialization failed with code: \(initResult.rawValue)", details: nil))
    //     }
    // }

}

extension SwiftZoomMeetingFlutterSdkMacosPlugin{

    // func joinAMeetingButtonPressed(meetingNumber: String, meetingPassword: String){
    //     //        requestSaveClientJoiningTime(id: id)

    //     // 1. The Zoom SDK requires a UINavigationController to update the UI for us. Here we are supplying the SDK with the ViewControllers' navigationController.
    //     MobileRTC.shared().setMobileRTCRootController(UIApplication.shared.keyWindow?.rootViewController?.navigationController)
    //     //     window?.makeKeyAndVisible()
    //     // start your meetingA
    //     //        joinMeeting(meetingNumber: meetingNumber, meetingPassword: meetingPassword)
    // }

    // func joinMeeting(meetingNumber: String, meetingPassword: String, displayName: String) {
    //     NSLog("Swift: joinMeeting")
    //     MobileRTC.shared().setMobileRTCRootController(UIApplication.shared.keyWindow?.rootViewController?.navigationController)
    //     if let meetingService = MobileRTC.shared().getMeetingService() {
    //         NSLog("Swift: meetingNumber  \(meetingNumber)")
    //         NSLog("Swift: meetingPassword  \(meetingPassword)")
    //         NSLog("Swift: displayName  \(displayName)")

    //         // Create a MobileRTCMeetingJoinParam to provide the MobileRTCMeetingService with the necessary info to join a meeting.
    //         // In this case, we will only need to provide a meeting number and password.
    //         meetingService.delegate = self

    //         let joinMeetingParameters = MobileRTCMeetingJoinParam()
    //         joinMeetingParameters.meetingNumber = meetingNumber
    //         joinMeetingParameters.password = meetingPassword
    //         joinMeetingParameters.userName = displayName
    //         joinMeetingParameters.noVideo = true
    //         joinMeetingParameters.noAudio = true

    //         // Call the joinMeeting function in MobileRTCMeetingService. The Zoom SDK will handle the UI for you, unless told otherwise.
    //         // If the meeting number and meeting password are valid, the user will be put into the meeting. A waiting room UI will be presented or the meeting UI will be presented.
    //         meetingService.muteMyVideo(true)
    //         meetingService.muteMyAudio(false)

    //         //            meetingService.video
    //         meetingService.joinMeeting(with: joinMeetingParameters)
    //     }else{
    //         NSLog("Swift: tim cock you retarded")

    //     }
    // }

}


extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}