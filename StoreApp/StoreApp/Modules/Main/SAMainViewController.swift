//
//  SAMainViewController.swift
//  StoreApp
//
//  Created by Josip Zidar on 12.05.2021..
//

import UIKit

final class SAMainViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    private var notes: [SANote] = [] {
        didSet {
            self.notes = self.notes.sorted(by: {$0.date > $1.date})
        }
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerNib()
    }
    
    private func setupUI() {
        title = "List"
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onTouchAddButton))
        self.navigationItem.rightBarButtonItem = addButton
        loadNotes()
    }
    
    @objc private func onTouchAddButton() {
        coordinator?.openForm()
    }
    
    private func registerNib() {
        tableView.registerNib(SANoteTableViewCell.self)
    }
    
    private func loadNotes() {
        let defaults = UserDefaults.standard
        
        guard let data = defaults.value(forKey: "Notes") as? Data else {
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let notes = try decoder.decode([SANote].self, from: data)
            self.notes = notes
            
        } catch {
            assertionFailure(error.localizedDescription)
        }
        
    }
    
    private func saveNotes() {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(notes)
            defaults.set(encodedData, forKey: "Notes")
            defaults.synchronize()
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
    
    final func addNewNote(note: SANote) {
        notes.append(note)
        saveNotes()
        tableView.reloadData()
        
    }
    
    final func editedNote() {
        saveNotes()
        tableView.reloadData()
    }
}
extension SAMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SANoteTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let note = notes[indexPath.row]
        cell.config(with: note)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let note = notes[indexPath.row]
        coordinator?.showNotesDetails(with: note)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
            guard let welf = self else { return }
            welf.notes.remove(at: indexPath.row)
            welf.tableView.reloadData()
            welf.saveNotes()
        }
       return UISwipeActionsConfiguration(actions: [delete])
    }
}
