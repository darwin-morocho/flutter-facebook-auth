import Flutter
import UIKit

import FBSDKCoreKit
import FBSDKLoginKit


public class SwiftFlutterFacebookAuthPlugin: NSObject, FlutterPlugin {
    
    let loginManager : LoginManager = LoginManager()
    
    public init(_ channel:FlutterMethodChannel) {
        
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_facebook_auth", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterFacebookAuthPlugin(channel)
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        let args = call.arguments as? [String: Any]
        
        switch call.method{
            
        case "login":
            let permissions = args?["permissions"] as! [String]
            self.login(permissions: permissions, flutterResult: result)
            
            
        case "isLogged":
            if AccessToken.isCurrentAccessTokenActive {
                result(AccessToken.current?.tokenString)
            }else{
                result(nil)
            }
            
            
        case "getUserData":
            let fields = args?["fields"] as! String
            getUserData(fields: fields, flutterResult: result)
            
        case "logOut":
            loginManager.logOut()
            result(nil)
            
            
            
        default:
            result(FlutterError(code: "404", message: "No such method", details: nil))
        }
        
    }
    
    
    
    private func login(permissions: [String], flutterResult: @escaping FlutterResult){
        
        let viewController: UIViewController = (UIApplication.shared.delegate?.window??.rootViewController)!
        
        loginManager.logIn(permissions: permissions, from: viewController, handler: { (result, error) -> Void in
            
            if(error==nil){
                let fbloginresult : LoginManagerLoginResult = result!
                if(fbloginresult.isCancelled) {
                    flutterResult(["status":403])
                    
                } else {
                    flutterResult(["status":200, "accessToken":fbloginresult.token!.tokenString])
                }
            } else{
                flutterResult(FlutterError(code: "500", message: "error make sure that your  Info.plist is configured", details: nil))
            }
            
        })
        
    }
    
    
    
    
    
    
    
    private func getUserData(fields: String, flutterResult: @escaping FlutterResult) {
        print("init getUserData:")
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":fields])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                print("error getUserData: \(String(describing: error))")
                flutterResult(FlutterError(code: "500", message: "error get user data from facebook Graph, please check your fileds and your permissions", details: nil))
            } else {
                let resultDic = result as! NSDictionary
                print("getUserData: \(resultDic)")
                flutterResult(resultDic)
            }
        })
    }
}
