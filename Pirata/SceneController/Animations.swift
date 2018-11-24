//
//  Animations.swift
//  Pirata
//
//  Created by Virgilius Santos on 19/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

class Animations {

    enum AnimationType {
        case slot ((CGPoint, Double)->(), (CGPoint, Double))
        case void (()->())
        case speed ((Double)->(), Double)
        case orientation ((Orientation, Float, Double)->(),(Orientation, Float, Double))
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.animations.isEmpty {
                return
            }
            let type = self.animations.removeFirst()
            switch type {
            case .slot(let (f, (p,s))):
                f(p,s)
            case .void(let void):
                void()
            case .orientation(let (f, (o,v,s))):
                f(o,v,s)
            case .slotSpeed(let (f, (s,v))):
                f(s,v)
            case .speed(let (f, s)):
                f(s)
            }
        }
    }
}
