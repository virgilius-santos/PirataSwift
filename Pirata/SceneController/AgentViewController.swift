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

    private func moveAnimation(center: CGPoint, speed: Double) {
        _agentImageView.moveAnimation(center: center, speed: speed) {
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
        let group = DispatchGroup()
        group.enter()
        var center: CGPoint!

        DispatchQueue.main.async {
            center = self._mapVC.center(fromSlot: to, to: self._rootView)
            group.leave()
        }

        // wait ...
        group.wait()

        let speed = self.Agent.speed
        self.animations.append(.slot(self.moveAnimation, (center, speed)))
    }

    func jump(to: Slot) {
        let group = DispatchGroup()
        group.enter()
        var center: CGPoint!

        DispatchQueue.main.async {
            center = self._mapVC.center(fromSlot: to, to: self._rootView)
            group.leave()
        }

        // wait ...
        group.wait()

        let speed = self.Agent.speed/2
        self.animations.append(.slot(self.moveAnimation, (center, speed)))
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
