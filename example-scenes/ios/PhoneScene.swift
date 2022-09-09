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
      let bridge = RCTBridge(delegate: appDelegate, connectionOptions: connectionOptions)
      let rootView = RCTRootView(bridge: bridge, moduleName: "example", initialProperties: nil)
      
      appDelegate.bridge = bridge
      appDelegate.rootView = rootView
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
