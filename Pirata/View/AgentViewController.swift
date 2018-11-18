//
//  AgentView.swift
//  Pirata
//
//  Created by Virgilius Santos on 17/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

class AgentViewController {

    var Agent: Agent
    var defaultLocation: Slot
    
    private weak var _rootView: UIView!
    private var _agentImageView: UIImageView!
    private var _mapVC: MapViewController

    init(agent: Agent, mapVC: MapViewController) {
        Agent = agent
        _mapVC = mapVC
        defaultLocation = agent.location
        
        agent.movementDelegate = self
    }

    func insertAgent(inView view: UIView) {
        _rootView = view

        let agentSlot = Agent.location

        _agentImageView?.removeFromSuperview()
        _agentImageView = UIImageView(image: agentSlot.type.image)
        _agentImageView.bounds = _mapVC.frame(fromSlot: agentSlot)
        _agentImageView.contentMode = .scaleAspectFit
        _agentImageView.center = _mapVC.center(fromSlot: agentSlot, to: _rootView)

        _rootView.addSubview(_agentImageView)
        print("\(#function)\n -\(agentSlot)\n")
    }

    func moveToStart() {
        move(to: defaultLocation) { }
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

    func goOut(direction: Direction, value: Float) {
        _agentImageView.goOut(
            direction: direction, value: CGFloat(value), speed: Agent.speed)
    }
    
}
