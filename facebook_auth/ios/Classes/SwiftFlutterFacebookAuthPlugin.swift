import Flutter
import UIKit

import FBSDKCoreKit


public class SwiftFlutterFacebookAuthPlugin: NSObject, FlutterPlugin, FlutterSceneLifeCycleDelegate {
    let facebookAuth = FacebookAuth()
    public static func register(with registrar: FlutterPluginRegistrar) {
        ApplicationDelegate.initialize()
        let channel = FlutterMethodChannel(name: "app.meedu/flutter_facebook_auth", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterFacebookAuthPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
        registrar.addSceneDelegate(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.facebookAuth.handle(call, result: result)
    }



    /// START ALLOW HANDLE NATIVE FACEBOOK APP
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable : Any] = [:]) -> Bool {
        var options = [UIApplication.LaunchOptionsKey: Any]()
        for (k, value) in launchOptions {
            let key = k as! UIApplication.LaunchOptionsKey
            options[key] = value
        }
        ApplicationDelegate.shared.application(application,didFinishLaunchingWithOptions: options)
        return true
    }

    public func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool {
        let processed = ApplicationDelegate.shared.application(
            app, open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        return processed;
    }

    // Scene lifecycle equivalent of `application(_:open:options:)`. iOS 13+
    // routes URL openings (including the native Facebook app callback via the
    // fb<APP_ID>:// scheme) here when UIApplicationSceneManifest is enabled.
    public func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        for context in URLContexts {
            _ = ApplicationDelegate.shared.application(
                UIApplication.shared,
                open: context.url,
                sourceApplication: context.options.sourceApplication,
                annotation: context.options.annotation as Any)
        }
    }
    /// END ALLOW HANDLE NATIVE FACEBOOK APP
}
