import UIKit
import Flutter
import FBSDKCoreKit // <--- ADD THIS LINE

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
    ) -> Bool {
        //ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)// <--- ADD THIS LINE
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    

    // <--- OVERRIDE THIS METHOD WITH THIS CODE
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if let facebookAppId: String = Bundle.main.object(forInfoDictionaryKey: "FacebookAppID") as? String {
            if url.scheme != nil && url.scheme!.hasPrefix("fb\(facebookAppId)") && url.host ==  "authorize" {
                return ApplicationDelegate.shared.application(app, open: url, options: options)
           }
        }
        return false
    }
}
