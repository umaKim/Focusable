//
//  AddressSection.swift
//  FocusExample
//
//  Created by 김윤석 on 11/24/24.
//

import UIKit

protocol AddressSectionDelegate: AnyObject {
    func didTapReturn() -> Bool
}

final class AddressSection: UIView, FocusableTextFieldDelegate {
    func didTapReturn() -> Bool {
        delegate?.didTapReturn() ?? false
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
    }
    
    weak var delegate: AddressSectionDelegate?
   
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Address"
        lb.textAlignment = .left
        lb.font = .boldSystemFont(ofSize: 15)
        return lb
    }()
    
    lazy var generalAddress: FocusableTextField = {
        let tf = FocusableTextField(.init(
            condition: { [weak self] in
                self?.generalAddress.textField.text?.isEmpty ?? true
            },
            focusAction: {
                print("focusedAction generalAddress")
                self.generalAddress.textField.becomeFirstResponder()
            }
        ))
        tf.delegate = self
        tf.backgroundColor = .orange
        tf.returnKeyType = .next
        return tf
    }()
    
    lazy var detailAddress: FocusableTextField = {
       let tf = FocusableTextField(.init(
        condition: { [weak self] in
            self?.detailAddress.textField.text?.isEmpty ?? true
        },
        focusAction: {
            print("focusedAction detailAddress")
            self.detailAddress.textField.becomeFirstResponder()
        }
    ))
        tf.delegate = self
        tf.backgroundColor = .blue
        tf.returnKeyType = .next
        return tf
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    private func setupUI() {
        let sv = UIStackView(arrangedSubviews: [titleLabel, generalAddress, detailAddress])
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
