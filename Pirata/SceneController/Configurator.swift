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

    let viewControllerIdentifier = String(describing: ViewController.self)

    var rootViewController: ViewController!
    
    var map: Map
    var mapVC: MapViewController!

    var agent: Agent!
    var startLocation: Slot
    var agentVC: AgentViewController!
    var brain: NeuralNet


    var animations: Animations

    init(window: UIWindow?) {
        self.window = window

        startLocation = Slot(index: Index(col: 1, row: 1))
        startLocation.set(type: .pirate)

        map = Map(square: 10)

        brain = NeuralNet()

        animations = Animations(filter: brain)

    }

    func configure() {

        mapVC = MapViewController(map: map)
        mapVC.animations = animations

        agentVC = AgentViewController(agentDS: mapVC, agentSlot: startLocation)
        agentVC.animations = animations

        rootViewController?.removeFromParent()
        rootViewController = ViewController(nibName: viewControllerIdentifier, bundle: nil)

        rootViewController.MapVC = mapVC
        rootViewController.AgentVC = agentVC
        rootViewController.configurator = self
        rootViewController.animations = animations

        window?.rootViewController = rootViewController
    }

    func next() {
        let total = agent.agentData.totalPoints
        brain.genetic.setarAptidoes(apt: Double(total))

        agent.reset()
        agent.moveToDefaultLocation()
        mapVC.restoreData()

        start()
    }

    func start() {
        let weights = brain.genetic.nextWeights
        agent = Agent(map: map, startLocation: startLocation, brain: brain, weights: weights)

        setDelegates()
        agent.start()
    }

    func setDelegates() {
        agent.delegate = rootViewController
        agent.mapAnimations = mapVC
        agent.movementAnimations = agentVC
    }

    func reset() {
        animations.reset()
        mapVC.reloadData()
        brain.reset()
        agent.reset()
        agentVC.reset()
    }
}
