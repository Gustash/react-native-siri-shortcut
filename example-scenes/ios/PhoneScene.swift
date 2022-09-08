import Foundation
import UIKit
import SwiftUI

class PhoneSceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else { return }
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    // Only initiate the bridge once
    if (appDelegate.bridge == nil) {
      // Build equivalent of launchOptions to pass to RCTBridge as we would have in didFinishLaunchingWithOptions
      // In this example we only add userActivity
      var launchOptions: [UIApplication.LaunchOptionsKey: Any] = [:];

      if !connectionOptions.userActivities.isEmpty {
        let userActivity = connectionOptions.userActivities.first;
        let userActivityDictionary = [
          "UIApplicationLaunchOptionsUserActivityTypeKey": userActivity?.activityType as Any,
          "UIApplicationLaunchOptionsUserActivityKey": userActivity!
        ] as [String : Any];
        launchOptions[UIApplication.LaunchOptionsKey.userActivityDictionary] = userActivityDictionary;
      }

      appDelegate.bridge = RCTBridge.init(delegate: appDelegate, launchOptions: launchOptions)
      appDelegate.rootView = RCTRootView.init(bridge: appDelegate.bridge!, moduleName: "example", initialProperties: nil)
    }

    let rootViewController = UIViewController()
    rootViewController.view = appDelegate.rootView;

    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = rootViewController
    self.window = window
    window.makeKeyAndVisible()
  }

  func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
    RNSSSiriShortcuts.scene(scene, continue: userActivity)
  }
}
