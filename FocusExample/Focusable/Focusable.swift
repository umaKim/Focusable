//
//  Focusable.swift
//  FocusExample
//
//  Created by 김윤석 on 11/10/24.
//

import UIKit

protocol Focusable: AnyObject {
    var focusableTarget: UITextField? { get }
    var isFocusedField: Bool { get }
    var children: [Focusable] { get }
}

extension Focusable {
    var shouldBecomeResponder: Void {
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

class FocusManager {
    static let shared = FocusManager()
    
    func dfs(node: any Focusable) {
        // Use a stack to keep track of nodes to visit
        var stack: [any Focusable] = [node]
        
        while !stack.isEmpty {
            // Pop the last node from the stack
            let currentNode = stack.removeLast()
            
            // Process the current node (here we just print if it's filled or not)
//            print("Node is filled: \(currentNode.isFilled)")
            
            // Push all children to the stack
            for child in currentNode.children {
                stack.append(child)
            }
        }
    }
    
    func dfsFindFocusable(_ node: (any Focusable)?) -> (any Focusable)? {
        guard let node = node else { return nil }

        // Check if the current node satisfies the condition
        if node.isFocusedField {
            return node
        }

        // Recur for each child
        for child in node.children {
            if let found = dfsFindFocusable(child) {
                return found
            }
        }

        return nil
    }
}
