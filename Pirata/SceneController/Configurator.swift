//
//  Configurator.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

class Configurator {

    var window: UIWindow?

    let storyboardName = "Main"
    let viewControllerIdentifier = String(describing: ViewController.self)

    var rootViewController: ViewController!
    
    var map: Map
    var mapVC: MapViewController!

    var agent: Agent
    var agentVC: AgentViewController!

    var animations: Animations

    init(window: UIWindow?) {
        self.window = window

        map = Map(square: 10)

        animations = Animations()

        let startLocation = Slot(index: Index(col: 1, row: 1))
        agent = Agent(map: map, startLocation: startLocation)
    }

    func start() {

        mapVC = MapViewController(map: map)
        mapVC.animations = animations

        agentVC = AgentViewController(agent: agent, mapVC: mapVC)
        agentVC.animations = animations

        rootViewController?.removeFromParent()
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        rootViewController = (storyboard.instantiateViewController(
            withIdentifier: viewControllerIdentifier) as! ViewController)

        rootViewController.MapVC = mapVC
        rootViewController.AgentVC = agentVC
        rootViewController.configurator = self
        rootViewController.animations = animations

        agent.delegate = rootViewController

        window?.rootViewController = rootViewController
    }

    func reset() {
        agent.reset()
//        rootViewController.removeFromParent()
//        agent.stop()
//        agent.reset()
//        start()
    }

    func next() {
        agent.start()
    }

}
