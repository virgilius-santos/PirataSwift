//
//  AgentMovementDelegate.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

protocol AgentMovementAnimations {
    func move(to: Slot, speed: Double)
    func startflip(speed: Double)
    func stopflip()
    func goOut(direction: Orientation, value: Float, speed: Double)
}

protocol AgentMapAnimations {
    func growUp(slot: Slot, speed: Double)
    func getBag(slot: Slot, speed: Double)
}

extension Agent {

    func moveView(to: Slot) {
        self.movementAnimations?.move(to: to, speed: self.speed)
    }

    func jumpView(to: Slot) {
        self.movementAnimations?.move(to: to, speed: self.speed/2)
    }

    func startflip() {
        self.movementAnimations?.startflip(speed: self.speed*2)
    }

    func stopflip() {
        self.movementAnimations?.stopflip()
    }

    func goOut(direction: Orientation, value: Float) {
        self.movementAnimations?
            .goOut(direction: direction, value: value, speed: self.speed)
    }

    func growUp(_ slot: Slot) {
        self.mapAnimations?.growUp(slot: slot, speed: self.speed)
    }

    func coletarBag(_ slot: Slot) {
        self.mapAnimations?.getBag(slot: slot, speed: self.speed)
    }

}
