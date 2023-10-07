//
//  Coordinator.swift
//  SmartList
//
//  Created by Zhiyuan Zhou on 10/1/23.
//

import Foundation
import UIKit

protocol Coordinator {
  var navigationController: UINavigationController? { get set }
  
  func start()
}
