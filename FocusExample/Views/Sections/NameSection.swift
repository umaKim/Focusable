//
//  NameSection.swift
//  FocusExample
//
//  Created by 김윤석 on 11/24/24.
//

import UIKit

protocol NameSectionDelegate: AnyObject {
    func didTapReturn() -> Bool
}

final class NameSection: UIView,
                         FocusableTextFieldDelegate, Focusable {
    
    weak var delegate: NameSectionDelegate?
    
    var focusableSection: UIView? { self }
    
    func didTapReturn() -> Bool {
        delegate?.didTapReturn() ?? false
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
    }
    
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Name"
        lb.textAlignment = .left
        lb.font = .boldSystemFont(ofSize: 15)
        return lb
    }()
    
    private lazy var lastName: FocusableTextField = {
       let tf = FocusableTextField(.init(
        condition: { [weak self] in
            self?.lastName.textField.text?.isEmpty ?? true
        },
        focusAction: {[weak self] in
            print("focusedAction lastName")
            self?.lastName.textField.becomeFirstResponder()
        }
    ))
        tf.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.backgroundColor = .orange
        tf.delegate = self
        tf.returnKeyType = .next
        return tf
    }()
    
    private lazy var firstName: FocusableTextField = {
       let tf = FocusableTextField(.init(
        condition: { [weak self] in
            self?.firstName.textField.text?.isEmpty ?? true
        },
        focusAction: {[weak self] in
            print("focusedAction firstName")
            self?.firstName.textField.becomeFirstResponder()
        }
    ))
//        tf.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.backgroundColor = .blue
        tf.delegate = self
        tf.returnKeyType = .next
        return tf
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    private func setupUI() {
        let sv = UIStackView(arrangedSubviews: [titleLabel, lastName, firstName])
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 6
        
        [sv].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            sv.leadingAnchor.constraint(equalTo: leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: trailingAnchor),
            sv.bottomAnchor.constraint(equalTo: bottomAnchor),
            sv.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
