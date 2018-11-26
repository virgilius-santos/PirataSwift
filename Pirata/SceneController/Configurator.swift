//
//  Configurator.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit
import PromiseKit

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
    var genetic: NeuralGenetic

    var animations: Animations

    init(window: UIWindow?) {
        self.window = window

        startLocation = Slot(index: Index(col: 1, row: 1))
        startLocation.set(type: .pirate)

        map = Map(square: 10)

        brain = NeuralNet()
        
        genetic = NeuralGenetic()
        genetic.popular(weight: brain.qtdWeights)

        animations = Animations(filter: genetic)

    }

    func configure() {

        mapVC = MapViewController(map: map)
        mapVC.animations = animations

        agentVC = AgentViewController(agentDS: mapVC, agentSlot: startLocation)
        agentVC.animations = animations

        rootViewController?.removeFromParent()
        rootViewController = ViewController(nibName: viewControllerIdentifier, bundle: nil)

        rootViewController.mapVC = mapVC
        rootViewController.agentVC = agentVC
        rootViewController.configurator = self
        rootViewController.animations = animations

        window?.rootViewController = rootViewController
    }

    func next() {
        let total = agent.agentData.totalPoints
        genetic.setarAptidoes(apt: Double(total))

        agent.reset()
        agent.moveToDefaultLocation()
        mapVC.restoreData()

        start()
    }

    func start() {
        let weights = genetic.nextWeights
        let genesis = genetic.genesis
        brain.setWeights(weights)
        agent = Agent(map: map,
                      startLocation: startLocation,
                      brain: brain,
                      genesis: genesis)
        
        setDelegates()
        
        agent
            .start()
            .done { evt in

                if case .terminar = evt {
                    self.next()
                }

                if case .completar = evt, !self.genetic.canShow {
                    self.next()
                }

        }
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
        genetic.popular(weight: brain.qtdWeights)

        agent.reset()
        agentVC.reset()
    }
}
