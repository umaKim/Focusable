//
//  Focusable.swift
//  FocusExample
//
//  Created by 김윤석 on 11/10/24.
//

import UIKit

protocol Focusable: AnyObject, UIView {
    var focusableTarget: UITextField? { get } //DS로 바꿔봐야한다.
    var children: [any Focusable] { get }
}

extension Focusable {
    var becomeFirstResponder: Void {
        focusableTarget?.becomeFirstResponder()
    }
    
    var isFocusable: Bool {
        focusableTarget != nil
    }
}

extension Focusable {
    var isFocusableTextEmpty: Bool {
        return focusableTarget?.text?.isEmpty ?? true
    }
}
