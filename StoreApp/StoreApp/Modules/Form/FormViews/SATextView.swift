//
//  SATextView.swift
//  StoreApp
//
//  Created by Josip Zidar on 13.05.2021..
//

import Foundation
import UIKit

protocol SATextViewDelegate: class {
    func textEntryShouldReturn(_ textField: SATextView) -> Bool
    func textEditingChanged(_ textView: SATextView)
    func isValidTextEntry(_ textField: SATextView) -> Bool
    func textFieldDidBeginEditing(_ textField: SATextView)
    func textFieldDidEndEditing(_ textField: SATextView)
}

extension SATextViewDelegate {
    func isValidTextEntry(_ textEntry: SATextView) -> Bool {return true}
    func textFieldDidBeginEditing(_ textField: SATextView) {}
    func textFieldDidEndEditing(_ textField: SATextView) {}
}

class SATextView: UIView {
    
    struct Configurator {
        let labelTitle: String?
        let currentText: String?
        let delegate: SATextViewDelegate?
    }
    
    private var titleLabel: UILabel = UILabel()
    private var textView: UITextView = UITextView()
    private var warningTextLabel: UILabel = UILabel()
    private weak var delegate: SATextViewDelegate?
    
    var text: String? {
        get {
            return textView.text
        }
        set(newValue) {
            textView.text = newValue
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
        self.addSubview(textView)
        self.addSubview(warningTextLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        warningTextLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        
        textView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5).isActive = true
        rightAnchor.constraint(equalTo: self.textView.rightAnchor, constant: 10).isActive = true
        textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        warningTextLabel.topAnchor.constraint(equalTo: self.textView.bottomAnchor, constant: 5).isActive = true
        textView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        warningTextLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 10).isActive = true
        warningTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        bottomAnchor.constraint(equalTo: self.warningTextLabel.bottomAnchor, constant: 5).isActive = true
        
        warningTextLabel.text = "Required field!"
        warningTextLabel.isHidden = true
        warningTextLabel.textColor = .red
        textView.delegate = self
        textView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        textView.layer.cornerRadius = 10
        
        textView.returnKeyType = .done
        textView.keyboardType = .default
        
    }
    
    final func config(with configurator: Configurator) {
        titleLabel.text = configurator.labelTitle
        textView.text = configurator.currentText
        delegate = configurator.delegate
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }
    
    override var isFirstResponder: Bool {
        return textView.isFirstResponder
    }
    
    final func isEntryValid() -> Bool {
        let text = self.text ?? ""

        if text.containsEmoji() {return false}
        return text.count >= 1
    }
    
    final func isEditable(status: Bool) {
        textView.isEditable = status
    }
}
extension SATextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.textColor = .black
        warningTextLabel.isHidden = true
        delegate?.textFieldDidBeginEditing(self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.textColor = isEntryValid() ? UIColor.black: UIColor.red
        warningTextLabel.isHidden = isEntryValid()
        delegate?.textFieldDidEndEditing(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let delegate = delegate else {return false}
        return delegate.textEntryShouldReturn(self)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        guard let delegate = delegate else {return}
        delegate.textEditingChanged(self)
    }
}
