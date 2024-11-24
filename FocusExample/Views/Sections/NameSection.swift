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
                         FocusableTextFieldDelegate,
                         Focusable {
    
    var focusableTarget: UITextField? { nil }
    
    weak var delegate: NameSectionDelegate?
    
    func didTapReturn() -> Bool {
        delegate?.didTapReturn() ?? false
    }
    
    var isFocusedField: Bool {
        false
    }
    
    lazy var children: [any Focusable] = [lastName, firstName]
    
    func textFieldDidChange(_ textField: UITextField) {
        print(lastName.isFocusedField)
        print(firstName.isFocusedField)
    }
    
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Name"
        lb.textAlignment = .left
        lb.font = .boldSystemFont(ofSize: 15)
        return lb
    }()
    
    private lazy var lastName: FocusableTextField = {
       let tf = FocusableTextField()
        tf.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        tf.backgroundColor = .orange
        tf.delegate = self
        tf.returnKeyType = .next
        return tf
    }()
    
    private lazy var firstName: FocusableTextField = {
       let tf = FocusableTextField()
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
