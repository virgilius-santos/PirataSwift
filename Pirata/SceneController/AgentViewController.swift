//
//  AgentView.swift
//  Pirata
//
//  Created by Virgilius Santos on 17/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

class AgentViewController {

    weak var Agent: Agent!

    weak var animations: Animations!
    
    private weak var _rootView: UIView!
    private weak var _agentImageView: UIImageView!
    private weak var _mapVC: MapViewController!

    init(agent: Agent, mapVC: MapViewController) {
        Agent = agent
        _mapVC = mapVC
        
        agent.movementDelegate = self
    }

    func insertAgent(inView view: UIView) {
        _rootView = view
        _agentImageView?.layer.removeAllAnimations()
        let agentSlot = Agent.location
        let agentImageView = UIImageView(image: agentSlot.type.image)
        agentImageView.bounds = _mapVC.frame(fromSlot: agentSlot)
        agentImageView.contentMode = .scaleAspectFit
        agentImageView.center = _mapVC.center(fromSlot: agentSlot, to: _rootView)
        _rootView.addSubview(agentImageView)
        _agentImageView = agentImageView
//        print("\(#function)\n -\(agentSlot)\n")
    }

    private func moveAnimation(to: Slot) {
        let center = _mapVC.center(fromSlot: to, to: _rootView)
        _agentImageView.moveAnimation(center: center, speed: Agent.speed) {
            self.animations.processAnimation()
        }
    }

    private func jumpAnimation(to: Slot) {
        let center = _mapVC.center(fromSlot: to, to: _rootView)
        _agentImageView.jumpAnimation(center: center, speed: Agent.speed/2) {
            self.animations.processAnimation()
        }
    }

    private func startflipAnimation() {
        _agentImageView.flip(speed: Agent.speed*2)
        self.animations.processAnimation()
    }

    private func stopflipAnimation() {
        #warning("implmentar stopflipAnimation()")
        print("error \(#function)")
        self.animations.processAnimation()
    }

    private func goOutAnimation(direction: Orientation, value: Float) {
        _agentImageView.goOut(direction: direction, value: CGFloat(value), speed: Agent.speed) {
            self.animations.processAnimation()
        }
    }

}

extension AgentViewController: AgentMovementDelegate {

    func slot(movement: Agent.Movement) -> Slot? {

        guard let newSlot = _mapVC.newSlot(fromSlot: Agent.location, movement: movement) else {
            return nil
        }
        return newSlot
    }

    func move(to: Slot) {
        animations.append(.slot(moveAnimation, to))
    }

    func jump(to: Slot) {
        animations.append(.slot(jumpAnimation, to))
    }

    func startflip() {
        animations.append(.void(startflipAnimation))
    }

    func stopflip() {
        animations.append(.void(stopflipAnimation))
    }

    func goOut(direction: Orientation, value: Float) {
        animations.append(.orientation(goOutAnimation, (direction, value)))
    }
    
}
