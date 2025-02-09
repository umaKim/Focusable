//
//  Focusable.swift
//  FocusExample
//
//  Created by 김윤석 on 11/10/24.
//

import UIKit

protocol Focusable: AnyObject, UIView, Hashable {
//    associatedtype T
//    var focusableTarget: T? { get } //DS로 바꿔봐야한다.
    
    //scroll되어야하는 Section view 정보
    // 만약 focusableSection이 nil이지만,
    // focusWrapper에 scrollview != nil,
    // Focusable이면서, focusableTarget != nil이라면
    // focusableTarget으로 scroll이 자동으로 된다.
    var focusableSection: UIView? { get }
    
    /// 해당 노드가 focus 되는 조건
    var focusableCondition: (() -> Bool) { get }
    
    /// 해당 노드가 focus되었을때 일어나야하는 Action
    var focusAction: (() -> Void) { get }
}

extension Focusable {
    var focusableSection: UIView? {
        nil
    }
    
    var focusableCondition: (() -> Bool) {
        { false }
    }
    
    var focusAction: (() -> Void) {
        { () }
    }
}
