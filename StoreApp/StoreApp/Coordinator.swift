//
//  Coordinator.swift
//  StoreApp
//
//  Created by Josip Zidar on 12.05.2021..
//

import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController? { get set }
    var childCoordinators: [Coordinator] { set get }
    
    func start()
}
