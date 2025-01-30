//
//  FocusTree.swift
//  FocusExample
//
//  Created by 김윤석 on 11/24/24.
//

import Foundation

final class FocusTree {
    private(set) var nodes: [any Focusable] = []
    
    func setFocusableNodes(_ nodes: any Focusable...) {
        self.nodes = nodes
    }
    
    func focusNext(
        for condition: ((any Focusable) ->(Bool)),
        nextNode: (((any Focusable)?) -> ())? = nil
    ) {
        for node in nodes {
            let node = dfsFindNextFocusable(
                condition: condition,
                node
            )
            nextNode?(node)
            return
        }
    }
    
    private func dfsFindNextFocusable(
        condition: ((any Focusable) ->(Bool)),
        _ node: any Focusable
    ) -> (any Focusable)? {
        
        for child in node.children {
            if condition(child) {
                return child
            }
            
            if let found = dfsFindNextFocusable(
                condition: condition,
                child
            ) {
                return found
            }
        }
        return nil
    }
}

final class FocusTree2 {
    private(set) var nodes: [any Focusable] = []
    
    func setFocusableNodes(_ nodes: [any Focusable]) {
        nodes.forEach { node in
            dfs(node, leafNodes: &self.nodes)
        }
    }
    
    private func dfs(
        _ node: any Focusable,
        leafNodes: inout [any Focusable]
    ) {
        if node.children.isEmpty,
           node.isFocusable {
            leafNodes.append(node)
        } else {
            for child in node.children {
                dfs(child, leafNodes: &leafNodes)
            }
        }
    }
}
