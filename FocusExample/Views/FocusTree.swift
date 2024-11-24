//
//  FocusTree.swift
//  FocusExample
//
//  Created by 김윤석 on 11/24/24.
//

import Foundation

final class FocusTree {
    
    var nodes: [Focusable] = []
    
    func focusNext(
        for condition: ((Focusable) ->(Bool))? = nil,
        nextNode: (Focusable?) -> ()
    ) {
        for node in nodes {
            let node = dfsFindNextFocusable(
                condition: condition,
                node
            )
            nextNode(node)
            return
        }
    }
    
    func dfsFindNextFocusable(
        condition: ((Focusable) ->(Bool))?,
        _ node: Focusable
    ) -> Focusable? {
        
        for child in node.children {
            if (condition?(child)) ?? true,
               child.isFocusable {
                return child
            }
            
            if let found = dfsFindNextFocusable(condition: condition, child) {
                return found
            }
        }
        return nil
    }
}
