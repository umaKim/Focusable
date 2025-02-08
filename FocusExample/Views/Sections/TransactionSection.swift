//
//  TransactionSection.swift
//  FocusExample
//
//  Created by 김윤석 on 11/24/24.
//

import UIKit

protocol TransactionSectionDelegate: AnyObject {
    func didTapReturn() -> Bool
}

final class TransactionSection: UIView, FocusableTextFieldDelegate, AddressSectionDelegate {
    
    func didTapReturn() -> Bool {
        delegate?.didTapReturn() ?? false
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        
    }
    
    weak var delegate: AddressSectionDelegate?
    
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Transaction"
        lb.textAlignment = .left
        lb.font = .boldSystemFont(ofSize: 15)
        return lb
    }()
    
    lazy var generalAddress: FocusableTextField = {
       let tf = FocusableTextField(.init(
        condition: { [weak self] in
            self?.generalAddress.textField.text?.isEmpty ?? true
        },
        focusAction: { [weak self] in
            print("focusedAction generalAddress")
            self?.generalAddress.textField.becomeFirstResponder()
        }
    ))
        tf.delegate = self
        tf.backgroundColor = .orange
        tf.returnKeyType = .next
        return tf
    }()
    
    lazy var childView = TransactionChildView()
    
    init() {
        super.init(frame: .zero)
        setupUI()
        
        childView.delegate = self
    }
    
    private func setupUI() {
        let sv = UIStackView(arrangedSubviews: [titleLabel, generalAddress, childView])
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
