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

final class TransactionSection: UIView, Focusable, FocusableTextFieldDelegate {
    
    func didTapReturn() -> Bool {
        delegate?.didTapReturn() ?? false
    }
    
    var focusableTarget: UITextField? { nil }
    
    var isFocusedField: Bool {
        false
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        print(generalAddress.isFocusedField)
        print(detailAddress.isFocusedField)
    }
    
    weak var delegate: AddressSectionDelegate?
    
    lazy var children: [any Focusable] = [generalAddress, detailAddress]
   
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Transaction"
        lb.textAlignment = .left
        lb.font = .boldSystemFont(ofSize: 15)
        return lb
    }()
    
    lazy var generalAddress: FocusableTextField = {
       let tf = FocusableTextField()
        tf.delegate = self
        tf.backgroundColor = .orange
        tf.returnKeyType = .next
        return tf
    }()
    
    lazy var detailAddress: FocusableTextField = {
       let tf = FocusableTextField()
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
