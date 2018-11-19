//
//  AgentMovementDelegate.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

protocol AgentMovementDelegate {
    func move(to: Slot)
    func jump(to: Slot)
    func startflip()
    func stopflip()
    func goOut(direction: Orientation, value: Float)
    func move(acao:Acao, direcao: Direction) -> Slot?
}

extension Agent {

    func move(acao:Acao, direcao: Direction) -> Slot? {
        return self.movementDelegate?.move(acao: acao, direcao: direcao)
    }

    func moveView(to: Slot) {
        self.movementDelegate?.move(to: to)
    }

    func jumpView(to: Slot) {
        self.movementDelegate?.jump(to: to)
    }

    func startflip() {
        self.movementDelegate?.startflip()
    }

    func stopflip() {
        self.movementDelegate?.stopflip()
    }

    func goOut(direction: Orientation, value: Float) {
        self.movementDelegate?.goOut(direction: direction, value: value)
    }

}
