//
//  AgentView.swift
//  Pirata
//
//  Created by Virgilius Santos on 17/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit
import PromiseKit

protocol AgentViewControllerDataSource {
    func frame(fromSlot slot: Slot) -> CGRect
    func center(fromSlot slot: Slot, to view: UIView) -> CGPoint
}

class AgentViewController {

    weak var animations: Animations!

    let agentSlot: Slot

    private(set) weak var rootView: UIView!
    private(set) weak var agentImageView: UIImageView!
    private(set) var agentDS: AgentViewControllerDataSource!

    init(agentDS: AgentViewControllerDataSource, agentSlot: Slot) {
        self.agentSlot = agentSlot
        self.agentDS = agentDS
    }

    func insertAgent(inView view: UIView) {
        rootView = view
        agentImageView?.layer.removeAllAnimations()
        let agentIV = UIImageView(image: agentSlot.type.image)
        agentIV.bounds = agentDS.frame(fromSlot: agentSlot)
        agentIV.contentMode = .scaleAspectFit
        agentIV.center = agentDS.center(fromSlot: agentSlot, to: rootView)
        rootView.addSubview(agentIV)
        agentImageView = agentIV
    }

    func reset() {
        agentImageView.center = agentDS.center(fromSlot: agentSlot, to: rootView)
    }
}

extension AgentViewController: AgentMovementAnimations {
    func move(to: Slot, speed: Double) {
        var center: CGPoint
        if Thread.isMainThread {
            center = self.agentDS.center(fromSlot: to, to: self.rootView)
        } else {
            center = DispatchQueue.main.async(.promise) {
                return self.agentDS.center(fromSlot: to, to: self.rootView)
            }.wait()
        }
        self.animations.append(.slot(self.moveAnimation, (center, speed)))
    }

    private func moveAnimation(center: CGPoint, speed: Double) -> Guarantee<Bool> {
        agentImageView.moveAnimation(center: center, speed: speed)
    }

    func goOut(direction: Orientation, value: Float, speed: Double) {
        animations.append(.orientation(goOutAnimation, (direction, value, speed)))
    }

    private func goOutAnimation(direction: Orientation, value: Float, speed: Double) -> Guarantee<Bool> {
        agentImageView
            .goOut(direction: direction, value: CGFloat(value), speed: speed)
    }
}
