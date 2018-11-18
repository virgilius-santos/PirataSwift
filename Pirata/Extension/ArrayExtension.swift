//
//  ArrayExtension.swift
//  Pirata
//
//  Created by Virgilius Santos on 17/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

extension Array where Array == [SlotView] {
    func stackView() -> UIStackView {
        let stack = UIStackView(arrangedSubviews: self)
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.spacing = 5
        stack.clipsToBounds = false
        return stack
    }
}
