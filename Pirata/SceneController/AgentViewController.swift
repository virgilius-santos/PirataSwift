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
        print("\(#function)\n -\(agentSlot)\n")
    }


}

extension AgentViewController: AgentMovementDelegate {

    func move(to: Slot, completion: @escaping () -> ()) {
        let center = _mapVC.center(fromSlot: to, to: _rootView)
        _agentImageView.moveAnimation(
            center: center, speed: Agent.speed, completion: completion)
    }

    func jump(to: Slot, completion: @escaping () -> ()) {
        let center = _mapVC.center(fromSlot: to, to: _rootView)
        _agentImageView.jumpAnimation(
            center: center, speed: Agent.speed/2, completion: completion)
    }

    func startflip() {
        _agentImageView.flip(speed: Agent.speed*2)
    }

    func stopflip(completion: @escaping () -> ()) {
        _agentImageView.layer.removeAllAnimations()
        completion()
    }

    func goOut(direction: Orientation, value: Float) {
        _agentImageView.goOut(
            direction: direction, value: CGFloat(value), speed: Agent.speed)
    }
    
}
