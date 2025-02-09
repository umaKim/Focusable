//
//  FocusSetter.swift
//  FocusExample
//
//  Created by 김윤석 on 2/9/25.
//

import Foundation

struct FocusSetter {
    let condition: (() -> Bool)
    let focusAction: () -> ()
}
