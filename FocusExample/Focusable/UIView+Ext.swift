//
//  UIView+Ext.swift
//  FocusExample
//
//  Created by 김윤석 on 2/9/25.
//

import UIKit

// 최종으로 거슬러 올라간 부모가 FocusWrapper이면 FocusWrapper를 return
// 아니라면 nil을 return
extension UIView {
    func findFocusWrapper(_ view: UIView) -> FocusWrappable? {
        if let focusWrapper = view as? FocusWrappable {
            return focusWrapper
        }
        
        if let superview = view.superview {
            if let focusWrapper = superview as? FocusWrappable {
                return focusWrapper
            }
            return findFocusWrapper(superview)
        }
        return nil
    }
}
