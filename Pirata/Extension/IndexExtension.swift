//
//  IndexExtension.swift
//  Pirata
//
//  Created by Virgilius Santos on 17/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

extension Index {
//    func slotView(fromMatriz matriz: [[SlotView]]) -> SlotView {
//        return matriz[col][row]
//    }

    /// calcula a distancia entre dois quadrados
    func calcDistance(from: Index) -> Int {
        let colSignal = from.col <= col ? 1 : -1
        let rowSignal = from.row <= row ? 1 : -1
        let colAux = (col - from.col) * colSignal
        let rowAux = (row - from.row) * rowSignal
        let soma = colAux + rowAux
        return soma
    }

    /// calcula a distancia entre dois quadrados
    func calcDistance(to: Index) -> Int {
        let colSignal = col <= to.col ? 1 : -1
        let rowSignal = row <= to.row ? 1 : -1
        let colAux = (to.col - col) * colSignal
        let rowAux = (to.row - row) * rowSignal
        let soma = colAux + rowAux
        return soma
    }
}
