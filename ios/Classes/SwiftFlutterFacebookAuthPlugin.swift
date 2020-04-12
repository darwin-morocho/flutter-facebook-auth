import Flutter
import UIKit

import FBSDKCoreKit
import FBSDKLoginKit

public class SwiftFlutterFacebookAuthPlugin: NSObject, FlutterPlugin {
    
    let loginManager : LoginManager = LoginManager()
    var pendingResult: FlutterResult? = nil
    
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_facebook_auth", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterFacebookAuthPlugin()
        
        registrar.addMethodCallDelegate(instance, channel: channel)
        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        let args = call.arguments as? [String: Any]
        
        switch call.method{
            
        case "login":
            let permissions = args?["permissions"] as! [String]
            self.login(permissions: permissions, flutterResult: result)
            
            
        case "isLogged":
            let isOK = setPendingResult(methodName: "isLogged", flutterResult: result)
            if(!isOK){
                return
            }
            if AccessToken.isCurrentAccessTokenActive {
             let accessToken =   getAccessToken(accessToken: AccessToken.current!)
              finishWithResult(data: accessToken as Dictionary)
            }else{
                finishWithResult(data: nil)
            }
            
            
        case "getUserData":
            let fields = args?["fields"] as! String
            getUserData(fields: fields, flutterResult: result)
            
        case "logOut":
            let isOK = setPendingResult(methodName: "logOut", flutterResult: result)
            if(!isOK){
                return
            }
            loginManager.logOut()
            finishWithResult(data: nil)
            
            
            
        default:
            result(FlutterError(code: "404", message: "No such method", details: nil))
        }
        
    }
    
    
    
    private func login(permissions: [String], flutterResult: @escaping FlutterResult){
        
        let isOK = setPendingResult(methodName: "login", flutterResult: flutterResult)
        if(!isOK){
            return
        }
        
        let viewController: UIViewController = (UIApplication.shared.delegate?.window??.rootViewController)!
        
        loginManager.logIn(permissions: permissions, from: viewController, handler: { (result, error) -> Void in
            
            if(error==nil){
                let fbloginresult : LoginManagerLoginResult = result!
                
                if(fbloginresult.isCancelled) {
                    self.finishWithResult(data: ["status":403])
                } else {
                    print("permissions",fbloginresult.grantedPermissions)
                    self.finishWithResult(data: [
                        "status":200,
                        "accessToken": self.getAccessToken(accessToken: fbloginresult.token!),
                        "grantedPermissions": Array(fbloginresult.grantedPermissions),
                        "declinedPermissions": Array(fbloginresult.declinedPermissions)
                    ])
                }
            } else{
                self.finishWithError(message: "error make sure that your  Info.plist is configured")
            }
            
        })
        
    }
    
    
    
    
    
    
    
    private func getUserData(fields: String, flutterResult: @escaping FlutterResult) {
        print("init getUserData:")
        
        let isOK = setPendingResult(methodName: "getUserData", flutterResult: flutterResult)
        if(!isOK){
            return
        }
        
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":fields])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                print("error getUserData: \(String(describing: error))")
                self.finishWithError(message: "error get user data from facebook Graph, please check your fileds and your permissions")
            } else {
                let resultDic = result as! NSDictionary
                self.finishWithResult(data: resultDic)
            }
        })
    }
    
    
    private func setPendingResult(methodName: String, flutterResult: @escaping FlutterResult) -> Bool {
        if(pendingResult != nil){
            pendingResult!(FlutterError(code: "500", message: "\(methodName) called while another Facebook login operation was in progress.", details: nil))
            
            return false
        }
        pendingResult = flutterResult;
        return true
    }
    
    private func finishWithResult(data: Any?){
        if (pendingResult != nil) {
            pendingResult!(data)
            pendingResult = nil
        }
    }
    
    
    private func finishWithError(message: String){
        if (pendingResult != nil) {
            pendingResult!(FlutterError(code: "500", message: message, details: nil))
            pendingResult = nil
        }
    }
    
    
    
    
    private func getAccessToken(accessToken: AccessToken) -> [String : Any] {
            
        print("permissions",accessToken.permissions)
        let data = [
            "token": accessToken.tokenString,
            "userId": accessToken.userID,
            "expires": Int64((accessToken.expirationDate.timeIntervalSince1970*1000).rounded())
            ] as [String : Any]
        
        return data;
        
    }
    
    
}
