import Flutter
import UIKit
import MobileRTC

public class SwiftZoomMeetingFlutterSdkPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        
        let channel = FlutterMethodChannel(name: "zoom_meeting_flutter_sdk", binaryMessenger: registrar.messenger())
        let instance = SwiftZoomMeetingFlutterSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)

    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        NSLog("Swift: initZoom .......")

        if call.method == "initZoom" {
            guard let args = call.arguments as? Dictionary<String, String> else { return }
            let jwtToken = args["jwtToken"] ?? ""
            setupSDK(jwtToken: jwtToken)
            result(true)
        }

        if call.method == "joinMeeting" {
            guard let args = call.arguments as? Dictionary<String, String> else { return }
            let meetingNumber = args["meetingNumber"] ?? ""
            let meetingPassword = args["meetingPassword"] ?? ""
            let displayName = args["displayName"] ?? ""


            self.joinMeeting(meetingNumber: meetingNumber, meetingPassword: meetingPassword, displayName: displayName)
        }

    }


    func getDeviceID() -> String {
        NSLog("Swift: getDeviceID")
        return UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString

    }

    func getRootController() -> UIViewController {
        NSLog("Swift: getRootController")
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first
        let topController = (keyWindow?.rootViewController)!
        return topController
    }
}
extension SwiftZoomMeetingFlutterSdkPlugin{

    func joinAMeetingButtonPressed(meetingNumber: String, meetingPassword: String){
        //        requestSaveClientJoiningTime(id: id)

        // 1. The Zoom SDK requires a UINavigationController to update the UI for us. Here we are supplying the SDK with the ViewControllers' navigationController.
        MobileRTC.shared().setMobileRTCRootController(UIApplication.shared.keyWindow?.rootViewController?.navigationController)
        //     window?.makeKeyAndVisible()
        // start your meetingA
        //        joinMeeting(meetingNumber: meetingNumber, meetingPassword: meetingPassword)
    }

    func joinMeeting(meetingNumber: String, meetingPassword: String, displayName: String) {
        NSLog("Swift: joinMeeting")
        MobileRTC.shared().setMobileRTCRootController(UIApplication.shared.keyWindow?.rootViewController?.navigationController)
        if let meetingService = MobileRTC.shared().getMeetingService() {
            NSLog("Swift: meetingNumber  \(meetingNumber)")
            NSLog("Swift: meetingPassword  \(meetingPassword)")
            NSLog("Swift: displayName  \(displayName)")

            // Create a MobileRTCMeetingJoinParam to provide the MobileRTCMeetingService with the necessary info to join a meeting.
            // In this case, we will only need to provide a meeting number and password.
            meetingService.delegate = self

            let joinMeetingParameters = MobileRTCMeetingJoinParam()
            joinMeetingParameters.meetingNumber = meetingNumber
            joinMeetingParameters.password = meetingPassword
            joinMeetingParameters.userName = displayName
            joinMeetingParameters.noVideo = true
            joinMeetingParameters.noAudio = true

            // Call the joinMeeting function in MobileRTCMeetingService. The Zoom SDK will handle the UI for you, unless told otherwise.
            // If the meeting number and meeting password are valid, the user will be put into the meeting. A waiting room UI will be presented or the meeting UI will be presented.
            meetingService.muteMyVideo(true)
            meetingService.muteMyAudio(false)

            //            meetingService.video
            meetingService.joinMeeting(with: joinMeetingParameters)
        }else{
            NSLog("Swift: tim cock you retarded")

        }
    }

}
extension SwiftZoomMeetingFlutterSdkPlugin: MobileRTCMeetingServiceDelegate {

    // Is called upon in-meeting errors, join meeting errors, start meeting errors, meeting connection errors, etc.
    public func onMeetingError(_ error: MobileRTCMeetError, message: String?) {
        switch error {
        case MobileRTCMeetError.passwordError:
            NSLog("Swift: MobileRTCMeeting   :   Could not join or start meeting because the meeting password was incorrect.")
        default:
            NSLog("Swift: MobileRTCMeeting   :   Could not join or start meeting with MobileRTCMeetError: \(error) \(message ?? "")")
        }
    }

    // Is called when the user joins a meeting.
    public func onJoinMeetingConfirmed() {
        NSLog("Swift: MobileRTCMeeting   :   Join meeting confirmed.")
    }

    // Is called upon meeting state changes.
    public func onMeetingStateChange(_ state: MobileRTCMeetingState) {
        NSLog("Swift: MobileRTCMeeting   :   Current meeting state: \(state.rawValue)")
        switch state{

        case .idle:
            NSLog("Swift: idle")
        case .connecting:
            NSLog("Swift: connecting")

        case .waitingForHost:
            NSLog("Swift: waitingForHost")

        case .inMeeting:
            NSLog("Swift: inMeeting")

        case .disconnecting:
            NSLog("Swift: disconnecting")

        case .reconnecting:
            NSLog("Swift: reconnecting")

        case .failed:
            NSLog("Swift: failed")

        case .ended:
            NSLog("Swift: ended")

        case .locked:
            NSLog("Swift: locked")

        case .unlocked:
            NSLog("Swift: unlocked")

        case .inWaitingRoom:
            NSLog("Swift: inWaitingRoom")

        case .webinarPromote:
            NSLog("Swift: webinarPromote")

        case .webinarDePromote:
            NSLog("Swift: webinarDePromote")

        case .joinBO:
            NSLog("Swift: joinBO")

        case .leaveBO:
            NSLog("Swift: leaveBO")

//         case .waitingExternalSessionKey:
//             print("waitingExternalSessionKey")
        @unknown default:
            break
        }
    }
}


extension Date {
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}



extension SwiftZoomMeetingFlutterSdkPlugin: MobileRTCAuthDelegate {

    /// setupSDK Creates, Initializes, and Authorizes an instance of the Zoom SDK. This must be called before calling any other SDK functions.

    /// - Parameters:
    ///   - jwtToken: refer to https://developers.zoom.us/docs/meeting-sdk/auth/
    func setupSDK(jwtToken: String) {
        let context = MobileRTCSDKInitContext()
        context.domain = "zoom.us"
        context.enableLog = false

        let sdkInitializedSuccessfully = MobileRTC.shared().initialize(context)

        if sdkInitializedSuccessfully == true, let authorizationService = MobileRTC.shared().getAuthService() {
            authorizationService.delegate = self
            authorizationService.jwtToken = jwtToken
            authorizationService.sdkAuth()
        }
    }

    // Result of calling sdkAuth(). MobileRTCAuthError_Success represents a successful authorization.
    public func onMobileRTCAuthReturn(_ returnValue: MobileRTCAuthError) {
        switch returnValue {
        case MobileRTCAuthError.success:
            NSLog("Swift: SDK successfully initialized.")
        case MobileRTCAuthError.keyOrSecretEmpty:
            NSLog("Swift: SDK Key/Secret was not provided. Replace sdkKey and sdkSecret at the top of this file with your SDK Key/Secret.")
        case MobileRTCAuthError.keyOrSecretWrong, MobileRTCAuthError.unknown:
            NSLog("Swift: SDK Key/Secret is not valid.")
        default:
            NSLog("Swift: SDK Authorization failed with MobileRTCAuthError: \(returnValue).")
        }
    }

    private func onMobileRTCLoginReturn(_ returnValue: Int) {
        switch returnValue {
        case 0:
            NSLog("Swift: Successfully logged in")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userLoggedIn"), object: nil)
        case 1002:
            NSLog("Swift: Password incorrect")
        default:
            NSLog("Swift: Could not log in. Error code: \(returnValue)")
        }
    }
    public func onMobileRTCLogoutReturn(_ returnValue: Int) {
        switch returnValue {
        case 0:
            NSLog("Swift: Successfully logged out")
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "userLoggedIn"), object: nil)
        default:
            NSLog("Swift: Could not log out. Error code: \(returnValue)")
        }
    }

    public func applicationWillTerminate(_ application: UIApplication) {
        // Obtain the MobileRTCAuthService from the Zoom SDK, this service can log in a Zoom user, log out a Zoom user, authorize the Zoom SDK etc.
        if let authorizationService = MobileRTC.shared().getAuthService() {

            // Call logoutRTC() to log the user out.
            authorizationService.logoutRTC()
        }
    }
}