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
    func center(fromSlot slot: Slot, to view: UIView) -> Guarantee<CGPoint>
}

class AgentViewController {

    weak var animations: Animations!

    let AgentSlot: Slot

    private(set) weak var RootView: UIView!
    private(set) weak var AgentImageView: UIImageView!
    private(set) var AgentDS: AgentViewControllerDataSource!

    init(agentDS: AgentViewControllerDataSource, agentSlot: Slot) {
        AgentSlot = agentSlot
        AgentDS = agentDS
    }

    func insertAgent(inView view: UIView) {
        RootView = view
        AgentImageView?.layer.removeAllAnimations()
        let agentImageView = UIImageView(image: AgentSlot.type.image)
        agentImageView.bounds = AgentDS.frame(fromSlot: AgentSlot)
        agentImageView.contentMode = .scaleAspectFit
        agentImageView.center = AgentDS.center(fromSlot: AgentSlot, to: RootView).value!
        RootView.addSubview(agentImageView)
        AgentImageView = agentImageView
    }

}

extension AgentViewController: AgentMovementAnimations {

    func move(to: Slot, speed: Double) {
        let center = self.AgentDS.center(fromSlot: to, to: self.RootView).wait()
        self.animations.append(.slot(self.moveAnimation, (center, speed)))
    }

    private func moveAnimation(center: CGPoint, speed: Double) -> Guarantee<Bool> {
        return AgentImageView.moveAnimation(center: center, speed: speed)
    }

    func goOut(direction: Orientation, value: Float, speed: Double) {
        animations.append(.orientation(goOutAnimation, (direction, value, speed)))
    }

    private func goOutAnimation(direction: Orientation, value: Float, speed: Double) -> Guarantee<Bool> {
        return AgentImageView
            .goOut(direction: direction, value: CGFloat(value), speed: speed)
    }

    func startflip(speed: Double) {
        //animations.append(.speed(startflipAnimation, speed))
    }

    private func startflipAnimation(speed: Double) -> Guarantee<Bool> {
        return AgentImageView.flip(speed: speed)
    }

    func stopflip() {
        //animations.append(.void(stopflipAnimation))
    }

    private func stopflipAnimation() {
        #warning("implmentar stopflipAnimation()")
        print("error \(#function)")
    }
}
