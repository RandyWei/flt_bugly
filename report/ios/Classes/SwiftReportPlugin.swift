import Flutter
import UIKit
import Bugly

public class SwiftReportPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "plugin.bughub.dev/report", binaryMessenger: registrar.messenger())
    let instance = SwiftReportPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as? [String: Any] ?? [:]
    if call.method == "postException" {
        
        let reason = arguments["message"] as? String
        let detail = arguments["detail"] as? String
        if reason==nil {return}
        let data = arguments["data"] as? [String: String] ?? [:]
        
        let callStack = detail?.components(separatedBy: "") ?? []
        Bugly.reportException(withCategory: 5, name: "Flutter Exception", reason: reason!, callStack: callStack, extraInfo: data, terminateApp: false)
        result(nil)
    } else if call.method == "setUserId" {
        let userId = arguments["userId"] as? String ?? ""
        Bugly.setUserIdentifier(userId)
        result(nil)
    } else if call.method == "putUserData" {
        let userDataList = arguments["userData"] as? Array<[String:String]> ?? []
        for userData in userDataList {
            Bugly.setUserValue(userData["key"] ?? "", forKey: userData["value"] ?? "")
        }
        result(nil)
    }
  }
    
}
