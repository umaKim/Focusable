//
//  ContentView.swift
//  FocusExample
//
//  Created by 김윤석 on 11/24/24.
//

import UIKit

protocol TempProtocol {
    
}

final class ContentView: UIView, NameSectionDelegate, AddressSectionDelegate, TempProtocol {
    
    
    func didTapReturn() -> Bool {
        focusWrapper.didTapNext()
        return true
    }
    
    private lazy var nameSection = NameSection()
    private lazy var addressSection = AddressSection()
    private lazy var transactionSection = TransactionSubView()
    
    let focusWrapper = FocusWrapper()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Set up UI
extension ContentView {
//    private func setupUI() {
//        nameSection.delegate = self
//        addressSection.delegate = self
//        transactionSection.delegate = self
//        
//        let view = focusWrapper
////                .setNextCondtion(.skipFilledOne)
//            .build {
//                [nameSection,
//                 addressSection,
//                 transactionSection]
//            }
//        addSubview(view)
//        view.frame = self.bounds
//        
//        
////        focusWrapper.set(self)
//    }
    
    private func setupUI() {
            nameSection.delegate = self
            addressSection.delegate = self
            transactionSection.delegate = self
            
            let view = focusWrapper.build {
                [nameSection,
                 addressSection,
                 transactionSection]
            }
            
            addSubview(view)
            
            view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
}
