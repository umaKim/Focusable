//
//  FocusWrapper.swift
//  FocusExample
//
//  Created by 김윤석 on 1/29/25.
//

import Foundation
import UIKit

enum FocusCondtionTypes {
    case `default`
    case skipFilledOne
    case custom((any Focusable) -> Bool)
}

final class FocusWrapper2 {
    private var condtion: FocusCondtionTypes = .default
    private let focusTree = FocusTree2()
    
    @discardableResult
    func setFocusableNodes(_ nodes: any Focusable...) -> Self {
        focusTree.setFocusableNodes(nodes)
        return self
    }
    
    @discardableResult
    func setNextCondtion(_ condition: FocusCondtionTypes) -> Self {
        self.condtion = condition
        return self
    }
    
    func build(with views: () -> [Focusable]) -> [UIView] {
        let views = views()
        focusTree.setFocusableNodes(views)
        return views
    }
    
    @discardableResult
    func setNextCondtion(_ customCondition: @escaping (any Focusable) -> Bool) -> Self {
        self.condtion = .custom(customCondition)
        return self
    }
    
    func didTapNext(completion: ((_ oldFocusable: any Focusable, _ newFocusable: any Focusable) -> Void)? = nil) {
        guard
            let currentIndex = focusTree.nodes
                .compactMap({ $0.focusableTarget })
                .firstIndex(where: { $0.isFirstResponder })
                .flatMap({$0})
        else { return }
        
        switch condtion {
        case .default:
            let nextNode = focusTree.nodes[currentIndex + 1]
            nextNode.becomeFirstResponder
            completion?(focusTree.nodes[currentIndex], nextNode)
            
        case .skipFilledOne:
            let nodes = focusTree.nodes
            if currentIndex < nodes.count - 1 {
                for index in (currentIndex + 1)..<nodes.count {
                    let nextNode = nodes[index]
                    if nextNode.isFocusableTextEmpty {
                        nextNode.becomeFirstResponder
                        completion?(nodes[currentIndex], nextNode)
                        return 
                    }
                }
            }
            
        case .custom(_):
            break
        }
    }
}
