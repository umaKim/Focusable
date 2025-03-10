//
//  FocusableTextField.swift
//  FocusExample
//
//  Created by 김윤석 on 11/24/24.
//

import UIKit

protocol FocusableTextFieldDelegate: AnyObject {
    func textFieldDidChange(_ textField: UITextField)
    func didTapReturn() -> Bool
}

extension FocusableTextField: Focusable {
    var focusAction: (() -> Void) {
        focusSetter?.focusAction ?? { () }
    }
    
    var focusableCondition: (() -> Bool) {
        focusSetter?.condition ?? { false }
    }
}

final class FocusableTextField: UIView {
    var focusableTarget: UITextField? { textField }
    
    weak var delegate: FocusableTextFieldDelegate?
    
    private var focusSetter: FocusSetter?
    
    var returnKeyType: UIReturnKeyType  {
        get {
            textField.returnKeyType
        }
        
        set {
            textField.returnKeyType = newValue
        }
    }
    
    lazy var textField: UITextField = {
       let tf = UITextField()
//        tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        tf.delegate = self
        return tf
    }()
    
    init(_ focusSetter: FocusSetter? = nil) {
        self.focusSetter = focusSetter
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.topAnchor.constraint(equalTo: topAnchor)
        ])
    }

    @objc
    func textFieldDidChange(_ textField: UITextField) {
        print("TextField value changed to: \(textField.text ?? "")")
        delegate?.textFieldDidChange(textField)
    }
    
}

extension FocusableTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("textFieldDidBeginEditing")
        print(textField.text)
        
        if let focusWrapper = findFocusWrapper(self) {
            focusWrapper.focusedByUserInteraction(self)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
        print(textField.text)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("textFieldDidChangeSelection")
        print(textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        print(textField.text)
        return delegate?.didTapReturn() ?? false
    }
}
