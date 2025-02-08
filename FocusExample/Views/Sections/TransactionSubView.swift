//
//  TransactionSubView.swift
//  FocusExample
//
//  Created by 김윤석 on 2/9/25.
//

import UIKit

final class TransactionSubView: UIView, AddressSectionDelegate {
    func didTapReturn() -> Bool {
        delegate?.didTapReturn() ?? false
    }
    
    private let ts = TransactionSection()
    
    weak var delegate: AddressSectionDelegate?
    
    init() {
        super.init(frame: .zero)
        
        addSubview(ts)
        ts.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ts.leadingAnchor.constraint(equalTo: leadingAnchor),
            ts.trailingAnchor.constraint(equalTo: trailingAnchor),
            ts.bottomAnchor.constraint(equalTo: bottomAnchor),
            ts.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        ts.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
