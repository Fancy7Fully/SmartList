//
//  SceneDelegate.swift
//  SmartList
//
//  Created by Zhiyuan Zhou on 10/1/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var appCoordinator: AppCoordinator?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    guard let scene = (scene as? UIWindowScene) else { return }
    let navigationController = UINavigationController()
    let tabBar = UITabBarController()
    UITabBar.appearance().tintColor = .black
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = .gray
    tabBar.tabBar.standardAppearance = appearance
    tabBar.tabBar.scrollEdgeAppearance = tabBar.tabBar.standardAppearance
    let vc = TodoListViewController(style: .plain)
    vc.tabBarItem.title = "aaaa"
    vc.tabBarItem.image = UIImage(systemName: "house")
    let vc2 = TodoListViewController(style: .grouped)
    vc2.tabBarItem.title = "bbbb"
    vc2.tabBarItem.image = UIImage(systemName: "house")
    let vc3 = TodoListViewController(style:.insetGrouped)
    vc3.tabBarItem.title = "cccc"
    vc3.tabBarItem.image = UIImage(systemName: "house")
    let nav1 = UINavigationController(rootViewController: vc)
    let nav2 = UINavigationController(rootViewController: vc2)
    let nav3 = UINavigationController(rootViewController: vc3)
    tabBar.viewControllers = [nav1, nav2, nav3]
//    UITabBar.appearance().barTintColor = .white
//    UITabBar.appearance().tintColor = .black
//    appCoordinator = AppCoordinator(navigationController: navigationController)
//    appCoordinator?.tabBarController = tabBar
//    appCoordinator?.start()
//    tabBar.view.backgroundColor = .gray
    
    window = UIWindow(windowScene: scene)
    window?.rootViewController = tabBar
    window?.makeKeyAndVisible()
  }

  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }

  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }


}

