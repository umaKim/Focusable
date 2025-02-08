//
//  TransactionChildView.swift
//  FocusExample
//
//  Created by 김윤석 on 2/9/25.
//

import UIKit

final class TransactionChildView: UIView, FocusableTextFieldDelegate {
    func textFieldDidChange(_ textField: UITextField) {
            
    }
    
    func didTapReturn() -> Bool {
        delegate?.didTapReturn() ?? false
    }
    
    weak var delegate: AddressSectionDelegate?
    
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
        addSubview(detailAddress)
        [detailAddress].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            detailAddress.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailAddress.trailingAnchor.constraint(equalTo: trailingAnchor),
            detailAddress.bottomAnchor.constraint(equalTo: bottomAnchor),
            detailAddress.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
