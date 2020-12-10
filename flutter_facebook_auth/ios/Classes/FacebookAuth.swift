//
//  FacebookAuth.swift
//  FBSDKCoreKit
//
//  Created by Darwin Morocho on 11/10/20.
//

import Flutter
import FBSDKCoreKit
import FBSDKLoginKit
import Foundation

class FacebookAuth: NSObject {
    
    let loginManager : LoginManager = LoginManager()
    var pendingResult: FlutterResult? = nil
    
    
    /*
     handle the platform channel
     */
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args = call.arguments as? [String: Any]
        switch call.method{
        
        case "login":
            let permissions = args?["permissions"] as! [String]
            self.login(permissions: permissions, flutterResult: result)
            
            
        case "isLogged":
            
            if let token = AccessToken.current, !token.isExpired {
                let accessToken = getAccessToken(accessToken: token)
                result(accessToken)
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
            result(FlutterMethodNotImplemented)
        }
    }
    
    
    
    /*
     use the facebook sdk to request a login with some permissions
     */
    private func login(permissions: [String], flutterResult: @escaping FlutterResult){
        
        let isOK = setPendingResult(methodName: "login", flutterResult: flutterResult)
        if(!isOK){
            return
        }
        
        let viewController: UIViewController = (UIApplication.shared.delegate?.window??.rootViewController)!
        
        let parsedPermissions =  permissions.map {val in Permission(stringLiteral: val)}
        
        loginManager.logIn(permissions: parsedPermissions, viewController: viewController){
            res in
            
            switch res {
            case let .success(_, _, token):
                self.finishWithResult(data:self.getAccessToken(accessToken: token ))
                
            case .cancelled:
                self.finishWithError(errorCode: "CANCELLED", message: "User has cancelled login with facebook")
                
            case let .failed(error):
                self.finishWithError(errorCode: "FAILED", message: error.localizedDescription)
            }
        }

    }
    
    
    /**
     retrive the user data from facebook, this could be fail if you are trying to get data without the user autorization permission
     */
    private func getUserData(fields: String, flutterResult: @escaping FlutterResult) {
        let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":fields])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            if (error != nil) {
                self.sendErrorToClient(result: flutterResult, errorCode: "FAILED", message: error!.localizedDescription)
            } else {
                let resultDic = result as! NSDictionary
                flutterResult(resultDic) // sned the response to the client
            }
        })
    }
    
    // define a login task
    private func setPendingResult(methodName: String, flutterResult: @escaping FlutterResult) -> Bool {
        if(pendingResult != nil){// if we have a previous login task
            sendErrorToClient(result: pendingResult!, errorCode: "OPERATION_IN_PROGRESS", message: "The method \(methodName) called while another Facebook login operation was in progress.")
            return false
        }
        pendingResult = flutterResult;
        return true
    }
    
    // send the success response to the client
    private func finishWithResult(data: Any?){
        if (pendingResult != nil) {
            pendingResult!(data)
            pendingResult = nil
        }
    }
    
    // handle the login errors
    private func finishWithError(errorCode:String,  message: String){
        if (pendingResult != nil) {
            sendErrorToClient(result: pendingResult!, errorCode: errorCode, message: message)
            pendingResult = nil
        }
    }
    
    // sends a error response to the client
    private func sendErrorToClient(result:FlutterResult,errorCode:String,  message: String){
        result(FlutterError(code: errorCode, message: message, details: nil))
    }
    
    /**
     get the access token data as a Dictionary
     */
    private func getAccessToken(accessToken: AccessToken) -> [String : Any] {
        let data = [
            "token": accessToken.tokenString,
            "userId": accessToken.userID,
            "expires": Int64((accessToken.expirationDate.timeIntervalSince1970*1000).rounded()),
            "lastRefresh":Int64((accessToken.refreshDate.timeIntervalSince1970*1000).rounded()),
            "applicationId":accessToken.appID,
            "isExpired":accessToken.isExpired,
            "graphDomain":accessToken.graphDomain,
            "grantedPermissions":accessToken.permissions.map {item in item.name},
            "declinedPermissions":accessToken.declinedPermissions.map {item in item.name},
        ] as [String : Any]
        return data;
    }
}

