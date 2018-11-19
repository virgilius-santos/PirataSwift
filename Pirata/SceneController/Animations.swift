//
//  Animations.swift
//  Pirata
//
//  Created by Virgilius Santos on 19/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

class Animations {

    enum AnimationType {
        case slot ((Slot)->(), Slot)
        case void (()->())
        case orientation ((Orientation, Float)->(),(Orientation, Float))
        case slotSpeed ((Slot, Double)->(),(Slot, Double))
    }

    var animations = [AnimationType]() {
        didSet {
            if oldValue.isEmpty {
                processAnimation()
            }
        }
    }

    func append(_ type: AnimationType) {
        animations.append(type)
    }

    func processAnimation() {
        DispatchQueue.main.async {
            if self.animations.isEmpty {
                return
            }

            let type = self.animations.removeFirst()
            switch type {
            case .slot(let (f, p)): f(p)
            case .void(let void): void()
            case .orientation(let (f, (o,v))): f(o,v)
            case .slotSpeed(let (f, (s,v))): f(s,v)
            }
        }
    }
}
