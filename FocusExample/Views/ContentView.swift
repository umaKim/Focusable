//
//  ContentView.swift
//  FocusExample
//
//  Created by 김윤석 on 11/24/24.
//

import UIKit

final class ContentView: UIView, NameSectionDelegate, AddressSectionDelegate {
    
    
    func didTapReturn() -> Bool {
        focusWrapper.didTapNext { oldFocusable, newFocusable in
            // 여기에서 해당 oldFocusable, newFocusable에 first responder처리를 할것인지 말것인지를 처리해줄수 있다.
            
            // newFocusable의 위치로 scroll하게도 가능하게 처리 할수 있다.
            
            oldFocusable.focusableTarget?.borderStyle = .none
            newFocusable.focusableTarget?.borderStyle = .roundedRect
            
            print("old: \(oldFocusable.focusableTarget?.text)")
            print("new \(newFocusable.focusableTarget?.text)")
            print("old: \(oldFocusable.focusableTarget?.bounds)")
            print("new \(newFocusable.focusableTarget?.bounds)")
            
            let frameInWindow1 = oldFocusable.convert(oldFocusable.bounds, to: nil)
            let frameInWindow2 = newFocusable.convert(newFocusable.bounds, to: nil)
            print(frameInWindow1)
            print(frameInWindow2)
        }
        return true
    }
    
    private lazy var nameSection = NameSection()
    private lazy var addressSection = AddressSection()
    private lazy var transactionSection = TransactionSection()
    
    let focusWrapper = FocusWrapper2()
    
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
    private func setupUI() {
        nameSection.delegate = self
        addressSection.delegate = self
        transactionSection.delegate = self
        let sv = UIStackView(
            arrangedSubviews:
                focusWrapper
                .setNextCondtion(.skipFilledOne)
                .build {
                    [nameSection,
                     addressSection,
                     transactionSection]
                }
        )
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
