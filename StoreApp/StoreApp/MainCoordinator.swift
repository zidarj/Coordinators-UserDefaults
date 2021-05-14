//
//  MainCoordinator.swift
//  StoreApp
//
//  Created by Josip Zidar on 12.05.2021..
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    var childCoordinators: [Coordinator] = [Coordinator]()
    
    init(with navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = SAMainViewController.instantiate()
        vc.coordinator = self
        navigationController?.pushViewController(vc, animated: false)
    }
    
    
    func openForm() {
        let vc = SAFormViewController()
        vc.coordinator = self
        vc.type = .add
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func addNewNote(note: SANote) {
        guard let vc = navigationController?.viewControllers.first as? SAMainViewController else { return }
        vc.addNewNote(note: note)
        navigationController?.popViewController(animated: true)
        
    }
    
    func showNotesDetails(with note: SANote) {
        let vc = SAFormViewController()
        vc.coordinator = self
        vc.type = .details
        vc.note = note
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showEditNote(with note: SANote) {
        let vc = SAFormViewController()
        vc.coordinator = self
        vc.type = .edit
        vc.note = note
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func editedNote() {
        guard let vc = navigationController?.viewControllers.first as? SAMainViewController else { return }
        vc.editedNote()
        navigationController?.popToRootViewController(animated: true)
    }
    
}
