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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.animations.isEmpty {
                return
            }
//            sleep(1)
            let type = self.animations.removeFirst()
            switch type {
            case .slot(let (f, (p,s))):
                f(p,s)
            case .void(let void):
                void()
            case .orientation(let (f, (o,v))):
                f(o,v)
            case .slotSpeed(let (f, (s,v))):
                f(s,v)
            }
        }
    }
}
