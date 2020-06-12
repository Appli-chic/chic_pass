import UIKit
import Flutter
import RNCryptor

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let securityChannel = FlutterMethodChannel(name: "applichic.com/chicpass",
                                                   binaryMessenger: controller.binaryMessenger)
        securityChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            if let args = call.arguments as? Dictionary<String, Any> {
                if call.method == "encrypt" {
                    let dataString: String = args["data"] as! String
                    let data = dataString.data(using: .utf8)
                    let password = args["password"] as! String
                    let encryptedData = RNCryptor.encrypt(data: data!, withPassword: password)
                    print("encrypt: " + encryptedData.base64EncodedString())
                    result(encryptedData.base64EncodedString())
                } else if call.method == "decrypt" {
                    do {
                        let dataString: String = args["data"] as! String
                        let data = Data.init(base64Encoded: dataString)!
                        let password = args["password"] as! String
                        let decryptedData = try RNCryptor.decrypt(data: data, withPassword: password)
                        let decryptedString = String(data: decryptedData, encoding: .utf8)!
                        result(decryptedString)
                    } catch {
                        print(error)
                    }
                }
            }
            
            return
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
}
