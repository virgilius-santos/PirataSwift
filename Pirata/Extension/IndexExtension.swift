//
//  IndexExtension.swift
//  Pirata
//
//  Created by Virgilius Santos on 17/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

extension Index {
    func slotView(fromMatriz matriz: [[SlotView]]) -> SlotView {
        return matriz[col][row]
    }
}
