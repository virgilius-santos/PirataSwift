//
//  Animations.swift
//  Pirata
//
//  Created by Virgilius Santos on 19/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit
import PromiseKit
import CancellablePromiseKit

protocol FilterAnimation {
    var canShow: Bool { get }
}

final class Animations {

    enum AnimationType {
        case slot ((CGPoint, Double) -> (Guarantee<Bool>), (CGPoint, Double))
        case void (() -> (Guarantee<Bool>))
        case speed ((Double) -> (Guarantee<Bool>), Double)
        case orientation ((Orientation, Float, Double) -> (Guarantee<Bool>), (Orientation, Float, Double))
        case slotSpeed ((Slot, Double) -> (Guarantee<Bool>), (Slot, Double))
        case fadeIn ((SlotView) -> (Guarantee<Bool>), SlotView)
    }

    let delay = 0.1

    lazy var chain: CancellablePromise<Void> = startTask()

    var animations = [AnimationType]() {
        didSet {
            if oldValue.isEmpty {
                process()
            }
        }
    }

    private var _filter: FilterAnimation

    init(filter: FilterAnimation) {
        _filter = filter
    }

    func startTask(_ promisse: Promise<Void> = Guarantee().asVoid()) -> CancellablePromise<Void> {
        return CancellablePromise(using: promisse, cancel: cancel)
    }

    func reset() {
        animations.removeAll()
        chain.cancel()
    }

    func cancel() {
        print("\(String(describing: Animations.self)) - \(#function)")
        chain = startTask()
    }

    func append(_ type: AnimationType) {

        if !_filter.canShow {
            return
        }
        animations.append(type)
    }

    func process() {
        if animations.isEmpty {
            return
        }
        let type = animations.removeFirst()

        chain = chain.then {
            let promisses = self.process(type).asVoid()
            return self.startTask(promisses.asVoid())
        }
    }

    func process(_ type: AnimationType) -> Guarantee<Bool> {
        switch type {
        case let .slot(f, (p, s)):
            return f(p, s)
        case let .void(void):
            return void()
        case let .orientation(f, (o, v, s)):
            return f(o, v, s)
        case let .slotSpeed(f, (s, v)):
            return f(s, v)
        case let .speed(f, s):
            return f(s)
        case let .fadeIn(f, s):
            return f(s)
        }
    }
}
