import Cocoa
import FlutterMacOS
import WebKit

public class FacebookAuthDesktopPlugin: NSObject, FlutterPlugin {
    
    var result: FlutterResult?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "app.meedu/facebook_auth_desktop", binaryMessenger: registrar.messenger)
        let instance = FacebookAuthDesktopPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "signIn":
            let args = call.arguments as! NSDictionary
            self.result = result
            _openWebview(url: args["signInUri"] as! String, targetUriFragment: args["redirectUri"] as! String)
            break
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    
    
    func _openWebview(url: String, targetUriFragment: String) {

        let appWindow = NSApplication.shared.windows.first!
        let webviewController = WebViewController()
        
        webviewController.targetUriFragment = targetUriFragment
        
        webviewController.onComplete = { (callbackUrl) -> Void in
            self.result?(callbackUrl)
            self.result = nil
        }
        
        webviewController.onDismissed = { () -> Void in
            self.result?(nil)
            self.result = nil
        }

        webviewController.loadUrl(url)
        appWindow.contentViewController?.presentAsModalWindow(webviewController)
    }
}






public class WebViewController: NSViewController, WKNavigationDelegate {

    var targetUriFragment: String?
    var onComplete: ((String?) -> Void)?
    var onDismissed: (() -> Void)?
    
    public override func loadView() {
        self.title = ""
        let webView = WKWebView(frame: NSMakeRect(0, 0,  980, 720))
        
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        
        view = webView
    }
    
    func loadUrl(_ url: String) {
        clearCookies()
        
        let url = URL(string: url)!
        let request = URLRequest(url: url)
        (view as! WKWebView).load(request)
    }
    
    func clearCookies() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow);
            return
        }
        
        let uriString = url.absoluteString
        
        if uriString.contains(targetUriFragment!) {
            decisionHandler(.cancel)
            onComplete!(uriString)
            dismiss(self)
        } else {
            decisionHandler(.allow)
        }
    }
    
    public override func viewDidDisappear() {
        onDismissed!();
    }
}
