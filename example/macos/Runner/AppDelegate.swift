import Cocoa
import FlutterMacOS
import ZoomSDK
import AuthenticationServices

@main
class AppDelegate: FlutterAppDelegate, ZoomSDKAuthDelegate, ZoomSDKMeetingServiceDelegate {
    var sdk = ZoomSDK.shared()

    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
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
                    self.initializeSDK(result: result)
                
                case "sdkAuth":
                    if let args = call.arguments as? [String: Any],
                       let jwtToken = args["jwtToken"] as? String {
                        self.authenticateSDK(jwtToken: jwtToken, result: result)
                    } else {
                        result(FlutterError(code: "INVALID_ARGUMENTS", message: "", details: nil))
                    }

                case "joinMeeting":
                    if let args = call.arguments as? [String: Any],
                       let meetingNumber = args["meetingNumber"] as? Int64,
                       let displayName = args["displayName"] as? String,
                       let password = args["password"] as? String {
                        self.joinMeeting(meetingNumber: meetingNumber, displayName: displayName, password: password, result: result)
                    } else {
                        result(FlutterError(code: "INVALID_ARGUMENTS", message: "", details: nil))
                    }
                default:
                    result(FlutterMethodNotImplemented)
            }
        }
        
        super.applicationDidFinishLaunching(notification)
    }

    private func initializeSDK(result: @escaping FlutterResult) {
        NSLog("Swift : call initializeSDK()");
        let initParams = ZoomSDKInitParams()
        initParams.zoomDomain = "zoom.us"
        initParams.enableLog = true
        let initResult = self.sdk.initSDK(with: initParams)
        NSLog("Swift : initializeSDK() : initResult = \(initResult)")
        if initResult != ZoomSDKError_Success {
            result(FlutterError(code: "INIT_FAILED", message: "SDK initialization failed", details: nil))
        }
        else{
            result(true)
        }
    }

    private func authenticateSDK( jwtToken: String, result: @escaping FlutterResult) {
        let authService = self.sdk.getAuthService();
        NSLog("Swift : call authenticateSDK()");

        authService.delegate = self
        let authContext = ZoomSDKAuthContext()
        authContext.jwtToken = jwtToken
        let authResult = authService.sdkAuth(authContext)
        NSLog("Swift : authenticateSDK() : authResult = \(authResult)")
        
        if authResult != ZoomSDKError_Success {
            result(FlutterError(code: "AUTH_FAILED", message: "SDK authentication failed", details: nil))
        }
        else{
            result(true)
        }
    }

    func onZoomSDKAuthReturn(_ returnValue: ZoomSDKAuthError) {
        if returnValue == ZoomSDKAuthError_Success {
            NSLog("SDK Auth Successful")
        } else {
            NSLog("SDK Auth Failed")
        }
    }

    func onZoomAuthIdentityExpired() {
        NSLog("Auth Identity Expired")
    }

    func onMeetingStatusChange(_ state: ZoomSDKMeetingStatus, meetingError error: ZoomSDKMeetingError, end reason: EndMeetingReason) {
        if state == ZoomSDKMeetingStatus_InMeeting {
            NSLog("Successfully joined the meeting")
        }
    }

    private func checkRequestResult(data: Data?, response: URLResponse?, error: Error?) -> Bool {
        if error != nil { return false }
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else { return false }
        guard data != nil else { return false }
        return true
    }


    private func joinMeeting(meetingNumber: Int64, displayName: String, password: String, result: @escaping FlutterResult) {
        guard let meetingService = self.sdk.getMeetingService() else {
            result(FlutterError(code: "SERVICE_UNAVAILABLE", message: "Failed to get meeting service", details: nil))
            return 
        }
        
        let joinParam = ZoomSDKJoinMeetingElements()
        joinParam.userType = ZoomSDKUserType_WithoutLogin;
        joinParam.webinarToken = nil;
        joinParam.customerKey = nil;
        joinParam.displayName = displayName 
        joinParam.meetingNumber = meetingNumber
        joinParam.password = password
        joinParam.isDirectShare = false
        joinParam.displayID = 0
        joinParam.isNoVideo = false
        joinParam.isNoAudio = false
        joinParam.vanityID = nil
        joinParam.zak = nil

        meetingService.joinMeeting(joinParam)
    }

}