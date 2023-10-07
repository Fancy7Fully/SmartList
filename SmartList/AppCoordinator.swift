//
//  AppCoordinator.swift
//  SmartList
//
//  Created by Zhiyuan Zhou on 10/1/23.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
  
  var navigationController: UINavigationController?
  var tabBarController: UITabBarController?
  
  func start() {
    let vc = ViewController()
    vc.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
//    navigationController?.pushViewController(vc, animated: true)
//    tabBarController = UITabBarController()
    tabBarController?.viewControllers = [vc]
//    tabBarController?.selectedIndex = 0
  }
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
}
