import UIKit
import React

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RCTBridgeDelegate {

  var window: UIWindow?
  var bridge: RCTBridge?;
  var rootView: RCTRootView?;

  static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }

  func sourceURL(for bridge: RCTBridge!) -> URL! {
    #if DEBUG
    return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index");
    #else
    return Bundle.main.url(forResource:"main", withExtension:"jsbundle")
    #endif
  }

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Initiation of RCTBridge has moved to configurationForConnecting handler below
    //  because when using Scenes, launchOptions is always empty
    return true
  }

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    let scene =  UISceneConfiguration(name: "Phone", sessionRole: connectingSceneSession.role)
    scene.delegateClass = PhoneSceneDelegate.self
    return scene
  }
}
