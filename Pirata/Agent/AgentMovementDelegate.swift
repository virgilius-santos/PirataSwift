//
//  AgentMovementDelegate.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

protocol AgentMovementDelegate {
    func move(to: Slot, completion: @escaping()->())
    func jump(to: Slot, completion: @escaping()->())
    func startflip()
    func stopflip(completion: @escaping()->())
    func goOut(direction: Orientation, value: Float)
    func move(acao:Acao, direcao: Direction, completion: @escaping(Slot?)->())
}

extension Agent {

    func move(acao:Acao, direcao: Direction, completion: @escaping(Slot?)->()) {
        DispatchQueue.main.async {
            self.movementDelegate?.move(acao: acao, direcao: direcao, completion: completion)
        }
    }

    func moveView(to: Slot, completion: @escaping()->()) {
        DispatchQueue.main.async {
            self.movementDelegate?.move(to: to, completion: completion)
        }
    }

    func jumpView(to: Slot, completion: @escaping()->()) {
        DispatchQueue.main.async {
            self.movementDelegate?.jump(to: to, completion: completion)
        }
    }

    func startflip() {
        DispatchQueue.main.async {
            self.movementDelegate?.startflip()
        }
    }

    func stopflip(completion: @escaping()->()) {
        DispatchQueue.main.async {
            self.movementDelegate?.stopflip(completion:completion)
        }
    }

    func goOut(direction: Orientation, value: Float) {
        DispatchQueue.main.async {
            self.movementDelegate?.goOut(direction: direction, value: value)
        }
    }

}
