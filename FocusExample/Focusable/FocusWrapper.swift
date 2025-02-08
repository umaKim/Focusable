//
//  FocusWrapper.swift
//  FocusExample
//
//  Created by 김윤석 on 1/29/25.
//

import Foundation
import UIKit

//enum FocusCondtionTypes {
//    case `default`
//    case skipFilledOne
//    case custom((any Focusable) -> Bool)
//}
//
//final class FocusWrapper2 {
//    private var condtion: FocusCondtionTypes = .default
//    private let focusTree = FocusTree2()
//    
//    @discardableResult
//    func setFocusableNodes(_ nodes: any Focusable...) -> Self {
//        focusTree.setFocusableNodes(nodes)
//        return self
//    }
//    
//    @discardableResult
//    func setNextCondtion(_ condition: FocusCondtionTypes) -> Self {
//        self.condtion = condition
//        return self
//    }
//    
//    func build(with views: () -> [UIView]) -> [UIView] {
//        let views = views()
//        focusTree.setFocusableNodes(views)
//        return views
//    }
//    
//    @discardableResult
//    func setNextCondtion(_ customCondition: @escaping (any Focusable) -> Bool) -> Self {
//        self.condtion = .custom(customCondition)
//        return self
//    }
//    
//    func didTapNext(completion: ((_ oldFocusable: any Focusable, _ newFocusable: any Focusable) -> Void)? = nil) {
//        guard
//            let currentIndex = focusTree.nodes
//                .compactMap({ $0.focusableTarget })
//                .firstIndex(where: { $0.isFirstResponder })
//                .flatMap({$0})
//        else { return }
//        
//        switch condtion {
//        case .default:
//            let nextNode = focusTree.nodes[currentIndex + 1]
//            nextNode.becomeFirstResponder
//            completion?(focusTree.nodes[currentIndex], nextNode)
//            
//        case .skipFilledOne:
//            let nodes = focusTree.nodes
//            if currentIndex < nodes.count - 1 {
//                for index in (currentIndex + 1)..<nodes.count {
//                    let nextNode = nodes[index]
//                    if nextNode.isFocusableTextEmpty {
//                        nextNode.becomeFirstResponder
//                        completion?(nodes[currentIndex], nextNode)
//                        return 
//                    }
//                }
//            }
//            
//        case .custom(_):
//            break
//        }
//    }
//}

enum LastFocusableReturnType {
    case backToFirstFocusable
    case backTo
}

protocol FocusWrappable {
    func focusedByUserInteraction(_ focusable: any Focusable)
}

final class FocusWrapper: UIView {
    
    private var currentNode: (any Focusable)? = nil
    
//    func build(with views: () -> [UIView]) -> UIView {
//        self.views = views()
//        
//        
//        let sv = UIStackView(
//            arrangedSubviews: self.views
//        )
//        sv.axis = .vertical
//        sv.alignment = .fill
//        sv.distribution = .fill
//        sv.spacing = 6
//        
//        [sv].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            addSubview($0)
//        }
//        
//        NSLayoutConstraint.activate([
//            sv.centerXAnchor.constraint(equalTo: centerXAnchor),
//            sv.centerYAnchor.constraint(equalTo: centerYAnchor),
//        ])
//        
////        self.views.forEach { view in
////            view.
////            addSubview(view)
////        }
//        
//        self.views.forEach { view in
//            if let fw = view.superview as? FocusWrapper {
//                print("superview is FocusWrapper")
//            }
//        }
//        return self
//    }
    
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
    
    func set(_ view: UIView) {
        addSubview(view)
    }
    
//    private var views: [UIView] = []
    
    private var nodes: [any Focusable] = []
    
    private var scrollView: UIScrollView?
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
        currentNode = setCurrentNode(nodes)
        focusAndScroll(to: currentNode)
    }
    
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
                
                print("setContentOffset \(focusableSection.frame.origin)")
                
                print("setContentOffset \(focusableSection.frame.width)")
                print("setContentOffset \(focusableSection.frame)")
                print("setContentOffset \(focusableSection.bounds)")
                scrollView?.setContentOffset(focusableSection.frame.origin, animated: true)
            }
        }
    }
    
    private func scroll(to currentNode: any Focusable) {
        if currentNode.focusableCondition() {
            if let focusableSection = findFocusableSection(of: currentNode) {
                
                print("setContentOffset \(focusableSection.frame.origin)")
                
                print("setContentOffset \(focusableSection.frame.width)")
                print("setContentOffset \(focusableSection.frame)")
                print("setContentOffset \(focusableSection.bounds)")
                scrollView?.setContentOffset(focusableSection.frame.origin, animated: true)
            }
        }
    }
//    private func findFocusableTargetNodes(of view: UIView) -> [Focusable] {
//        for subview in view.subviews {
//            if let focusable = subview as? Focusable,
//               focusable.focusableTarget != nil {
//                nodes.append(focusable)
//            } else {
//                
//            }
//        }
//    }
    
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
    
    private func collectFocusableTargets(from view: UIView, nodes: inout [any Focusable]) {
        for subview in view.subviews {
            if let focusable = subview as? (any Focusable), focusable.focusableSection == nil {
                nodes.append(focusable)
            } else {
                collectFocusableTargets(from: subview, nodes: &nodes)
            }
        }
    }
    
    private func setCurrentNode(_ nodes: [any Focusable]) -> (any Focusable)? {
        guard let index = nodes.firstIndex(
            where: { $0 === currentNode }
        )
        else {
            return nodes.first
        }
        print("index: \(index)")
        print("next index: \(index + 1)")
        let newIndex = index + 1
        if nodes.count <= newIndex {
            return nil
        }
        return nodes[index + 1]
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


// 현재 문제
// 마지막 노드에서 어떤 노드로 가야하는가
