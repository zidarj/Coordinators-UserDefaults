//
//  SATextField.swift
//  StoreApp
//
//  Created by Josip Zidar on 12.05.2021..
//

import UIKit

protocol SATextFieldDelegate: class {
    func textEntryShouldReturn(_ textField: SATextField) -> Bool
    func textEditingChanged(_ textField: SATextField)
    func isValidTextEntry(_ textField: SATextField) -> Bool
    func textFieldDidBeginEditing(_ textField: SATextField)
    func textFieldDidEndEditing(_ textField: SATextField)
}

extension SATextFieldDelegate {
    func isValidTextEntry(_ textEntry: SATextField) -> Bool {return true}
    func textFieldDidBeginEditing(_ textField: SATextField) {}
    func textFieldDidEndEditing(_ textField: SATextField) {}
}

class SATextField: UIView {
    
    struct Configurator {
        let labelTitle: String?
        let placeholderText: String?
        let currentText: String?
        let delegate: SATextFieldDelegate?
    }
    
    private var titleLabel: UILabel = UILabel()
    private var textField: UITextField = UITextField()
    private var warningTextLabel: UILabel = UILabel()
    private weak var delegate: SATextFieldDelegate?
    private var editableStatus: Bool = true
    
    var text: String? {
        get {
            return textField.text
        }
        set(newValue) {
            textField.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.addSubview(titleLabel)
        self.addSubview(textField)
        self.addSubview(warningTextLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        warningTextLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
        
        textField.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5).isActive = true
        rightAnchor.constraint(equalTo: self.textField.rightAnchor, constant: 10).isActive = true
        textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        warningTextLabel.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 5).isActive = true
        
        
        warningTextLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10).isActive = true
        warningTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        bottomAnchor.constraint(equalTo: self.warningTextLabel.bottomAnchor, constant: 5).isActive = true
        
        warningTextLabel.text = "Required field!"
        warningTextLabel.isHidden = true
        warningTextLabel.textColor = .red
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        
        textField.returnKeyType = .done
        textField.keyboardType = .default
    }
    
    final func config(with configurator: Configurator) {
        titleLabel.text = configurator.labelTitle
        textField.placeholder = configurator.placeholderText
        textField.text = configurator.currentText
        delegate = configurator.delegate
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    
    override var isFirstResponder: Bool {
        return textField.isFirstResponder
    }
    
    @objc private func textFieldEditingChanged() {
        guard let delegate = delegate else {return}
        delegate.textEditingChanged(self)
    }
    
    final func isEntryValid() -> Bool {
        let text = self.text ?? ""

        if text.containsEmoji() {return false}
        return text.count >= 1
    }
    
    final func isEditable(status: Bool) {
        editableStatus = status
    }
}
extension SATextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = .black
        warningTextLabel.isHidden = true
        delegate?.textFieldDidBeginEditing(self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.textColor = isEntryValid() ? UIColor.black: UIColor.red
        warningTextLabel.isHidden = isEntryValid()
        delegate?.textFieldDidEndEditing(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let delegate = delegate else {return false}
        return delegate.textEntryShouldReturn(self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return editableStatus
    }
}

