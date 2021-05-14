//
//  SAFormViewController.swift
//  StoreApp
//
//  Created by Josip Zidar on 12.05.2021..
//

import UIKit

class SAFormViewController: UIViewController, Storyboarded {
    
    enum screenType: String {
        case add = "Add Note"
        case edit = "Edit Note"
        case details = "Details"
    }
    
    weak var coordinator: MainCoordinator?
    var type: screenType = .add
    var note: SANote?
    
    private var headerView: UIView!
    private var titleTextField: SATextField!
    private var dateTextField: SATextField!
    private var textView: SATextView!
    private var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configUI()
        enableSaveButton()
        
    }
    
    private func setupUI() {
        title = type.rawValue
        self.view.backgroundColor = .white
        headerView = UIView()
        headerView.backgroundColor = .white
        self.view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        titleTextField = SATextField()
        headerView.addSubview(titleTextField)
        let config = SATextField.Configurator(labelTitle: "Title:", placeholderText: "Infile Title", currentText: nil, delegate: self)
        titleTextField.config(with: config)
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.topAnchor.constraint(equalTo: self.headerView.topAnchor).isActive = true
        titleTextField.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor).isActive = true
        titleTextField.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor).isActive = true
        textView = SATextView()
        headerView.addSubview(textView)
        if type != .add {
            dateTextField = SATextField()
            headerView.addSubview(dateTextField)
            let configDate = SATextField.Configurator(labelTitle: "Date:", placeholderText: "Infile Date", currentText: nil, delegate: self)
            dateTextField.config(with: configDate)
            dateTextField.translatesAutoresizingMaskIntoConstraints = false
            titleTextField.bottomAnchor.constraint(equalTo: self.dateTextField.topAnchor).isActive = true
            dateTextField.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor).isActive = true
            dateTextField.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor).isActive = true
            dateTextField.isUserInteractionEnabled = false
            dateTextField.bottomAnchor.constraint(equalTo: self.textView.topAnchor).isActive = true
        } else {
            titleTextField.bottomAnchor.constraint(equalTo: self.textView.topAnchor).isActive = true
        }
        let configTextView = SATextView.Configurator(labelTitle: "Note:", currentText: nil, delegate: self)
        textView.config(with: configTextView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor).isActive = true
        
        saveButton = UIButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .systemBlue
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(ontouchSaveButton(_:)), for: .touchUpInside)
        headerView.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        textView.bottomAnchor.constraint(equalTo: self.saveButton.topAnchor).isActive = true
        saveButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 10).isActive = true
        headerView.trailingAnchor.constraint(equalTo: saveButton.trailingAnchor, constant: 10).isActive = true
        
    }
    
    private func configUI() {
        switch type {
        case .add:
            titleTextField.becomeFirstResponder()
            
        case .edit:
            guard let note = self.note else {
                return
            }
            dateTextField.text = note.date.dateToString
            titleTextField.text = note.title
            textView.text = note.note
            
        case .details:
            saveButton.isHidden = true
            titleTextField.isEditable(status: false)
            textView.isEditable(status: false)
            guard let note = self.note else {
                return
            }
            dateTextField.text = note.date.dateToString
            titleTextField.text = note.title
            textView.text = note.note

            let editButton: UIBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(onTouchEditButton))
            self.navigationItem.rightBarButtonItem = editButton
        }
    }
    
    @objc private func onTouchEditButton() {
        guard  let note = self.note else {
            return
        }
        coordinator?.showEditNote(with: note)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func ontouchSaveButton(_ sender: UIButton) {
        guard let title = titleTextField.text, let noteText = textView.text else { return }
        if !title.isEmpty && !noteText.isEmpty {
            switch type {
            case .add:
                let newNote = SANote(with: title, note: noteText, date: Date())
                coordinator?.addNewNote(note: newNote)
            case .edit:
                guard let note = self.note else {
                    return
                }
                note.title = title
                note.note = noteText
                coordinator?.editedNote()
            case .details:
                break
            }
            
        }
    }
    
    private func enableSaveButton() {
        let isEnabled: Bool = (textView.isEntryValid() && titleTextField.isEntryValid())
        saveButton.isEnabled = isEnabled
        saveButton.alpha = isEnabled ? 1 : 0.5
        
    }
}
extension SAFormViewController: SATextFieldDelegate {
    func textEditingChanged(_ textField: SATextField) {
        enableSaveButton()
    }
    
    func textEntryShouldReturn(_ textField: SATextField) -> Bool {
        if !textView.isFirstResponder && !textView.isEntryValid() {
            textView.becomeFirstResponder()
        } else if type == .add {
            view.endEditing(true)
        }
        return true
    }
    
}
extension SAFormViewController: SATextViewDelegate {
    func textEditingChanged(_ textView: SATextView) {
        enableSaveButton()
    }
    
    
    func textEntryShouldReturn(_ textView: SATextView) -> Bool {
        if !titleTextField.isFirstResponder && !titleTextField.isEntryValid() {
            titleTextField.becomeFirstResponder()
        }
        return true
    }
}
