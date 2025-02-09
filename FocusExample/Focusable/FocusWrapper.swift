//
//  FocusWrapper.swift
//  FocusExample
//
//  Created by 김윤석 on 1/29/25.
//

import Foundation
import UIKit

protocol FocusWrappable {
    func focusedByUserInteraction(_ focusable: any Focusable)
}

final class FocusWrapper: UIView {
    private var currentNode: (any Focusable)? = nil
    private var nodes: [any Focusable] = []
    private var scrollView: UIScrollView?
}

extension FocusWrapper {
    func build(with views: () -> [UIView]) -> UIView {
        let views = views()
        
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 6
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9) // Adjust width dynamically
        ])
        
        return self
    }
}

extension FocusWrapper {
    // currentNode에서 다음 node를 찾아주면 된다.
    // 이때
    // Focusable들중에 focusableTarget이 nil이 아닌것들을 차례대로 가지면 된다.
    // 그것들을 Array로 모은다
    // 그 Array를 순회하면서 focus가 되어 있는 애를 찾는다.
    func didTapNext() {
        nodes.removeAll()
        collectFocusableTargets(from: self, nodes: &nodes)
        currentNode = findNextNode(of: currentNode, from: nodes)
        focusAndScroll(to: currentNode)
    }
}

extension FocusWrapper {
    private func collectFocusableTargets(
        from view: UIView,
        nodes: inout [any Focusable]
    ) {
        for subview in view.subviews {
            if let focusable = subview as? (any Focusable),
               focusable.focusableSection == nil {
                nodes.append(focusable)
            } else {
                collectFocusableTargets(from: subview, nodes: &nodes)
            }
        }
    }
}

extension FocusWrapper {
    private func findNextNode(
        of currentNode: (any Focusable)?,
        from nodes: [any Focusable]
    ) -> (any Focusable)? {
        
        func findNextNode(
            from nodes: [any Focusable],
            beginIndex: Int,
            lastIndex: Int
        ) -> (any Focusable)? {
            if beginIndex > lastIndex { return nil }
            for newIndex in beginIndex...lastIndex {
                if nodes[newIndex].focusableCondition() {
                    return nodes[newIndex]
                }
            }
            return nil
        }
        
        guard let currentNode else { return nil }
        guard
            let currentIndex = nodes.firstIndex(
                where: { $0 === currentNode }
            ),
            let lastIndex = nodes.lastIndex(
                where: { $0 === nodes.last }
            )
        else { return currentNode }
        
        let nextIndex = currentIndex + 1
        
        if let newNode = findNextNode(
            from: nodes,
            beginIndex: nextIndex,
            lastIndex: lastIndex
        ) {
            return newNode
        }
        
        if let newNode = findNextNode(
            from: nodes,
            beginIndex: 0,
            lastIndex: nextIndex
        ) {
            return newNode
        }
        
        return currentNode
    }
}

extension FocusWrapper {
    private func focusAndScroll(to currentNode: (any Focusable)?) {
        if let currentNode {
            focus(on: currentNode)
            scroll(to: currentNode)
        }
    }
    
    private func focus(on currentNode: any Focusable) {
        if currentNode.focusableCondition() {
            currentNode.focusAction()
            
            if let focusableSection = findFocusableSection(of: currentNode) {
                scrollView?.setContentOffset(focusableSection.frame.origin, animated: true)
            }
        }
    }
    
    private func scroll(to currentNode: any Focusable) {
        if currentNode.focusableCondition() {
            if let focusableSection = findFocusableSection(of: currentNode) {
                scrollView?.setContentOffset(focusableSection.frame.origin, animated: true)
            }
        }
    }
    
    private func findFocusableSection(of currentNode: UIView) -> UIView? {
        if let superView = currentNode.superview {
            if let focusable = superView as? (any Focusable),
               let _ = focusable.focusableSection {
                return focusable
            } else {
                return findFocusableSection(of: superView)
            }
        }
        return nil
    }
}

// user와 interact되어 Focus된 Focusable이
// 자신이 currentNode라는것을
// Focuswrapper에 알려줘야한다.
extension FocusWrapper: FocusWrappable {
    func focusedByUserInteraction(_ focusable: any Focusable) {
        currentNode = focusable
        focusAndScroll(to: focusable)
    }
}
