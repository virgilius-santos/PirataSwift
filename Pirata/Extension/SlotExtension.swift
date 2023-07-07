//
//  SlotExtension.swift
//  Pirata
//
//  Created by Virgilius Santos on 17/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

extension Slot {
    func slotView() -> SlotView {
        let slotView = SlotView()
        slotView.row = self.index.row
        slotView.col = self.index.col
        slotView.imageView.image = self.type.image
        slotView.imageType = self.type
        return slotView
    }

    func slotView(fromMatriz matriz: [[SlotView]]) -> SlotView {
        return index.slotView(fromMatriz: matriz)
    }
}
