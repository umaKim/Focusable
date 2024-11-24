//
//  ContentView.swift
//  FocusExample
//
//  Created by 김윤석 on 11/24/24.
//

import UIKit

final class ContentView: UIView, NameSectionDelegate, AddressSectionDelegate, Focusable {
    
    var focusableTarget: UITextField? = nil
    
    var isFocusedField: Bool = false
    
    lazy var children: [any Focusable] = [
        nameSection,
        addressSection,
        transactionSection
    ]
    
    func didTapReturn() -> Bool {
//        focusTree.dfs(condition: { item in
////            !(item.focusableTarget?.text?.isEmpty ?? true) &&
////            !isFocusedField
//            !item.isFocusedField && item.isFocusableTextEmpty
//        }) { node in
//            node?.shouldBecomeResponder
//        }
        
        
//        focusTree.focusNext { obj in
//            obj.focusableTarget?.text?.isEmpty ?? false
//        } nextNode: { obj in
//            obj?.shouldBecomeResponder
//        }
        
        focusTree.focusNext(for: {
            !($0.focusableTarget?.hasText ?? true)
        }) { obj in
            obj?.shouldBecomeResponder
        }

        return true
    }
    
    private lazy var nameSection = NameSection()
    private lazy var addressSection = AddressSection()
    private lazy var transactionSection = TransactionSection()
    
    let focusTree = FocusTree()
    
    init() {
        super.init(frame: .zero)
        setupUI()
        
        focusTree.nodes = [self]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        nameSection.delegate = self
        addressSection.delegate = self
        transactionSection.delegate = self
        let sv = UIStackView(arrangedSubviews: [
            nameSection,
            addressSection,
            transactionSection
        ])
        sv.axis = .vertical
        sv.alignment = .fill
        sv.distribution = .fill
        sv.spacing = 6
        
        [sv].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            sv.centerXAnchor.constraint(equalTo: centerXAnchor),
            sv.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

