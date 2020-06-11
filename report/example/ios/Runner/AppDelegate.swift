import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    ReportPlugin.start(withAppId: "b4ac5c861e", true)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
