import Cocoa
import FlutterMacOS
import ZoomSDK

@main
class AppDelegate: FlutterAppDelegate {
    
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
    
    func initSDK(){
        // let sdk = ZoomSDK()
//        sdk.initSDK(with: <#T##ZoomSDKInitParams#>)
    }
}
