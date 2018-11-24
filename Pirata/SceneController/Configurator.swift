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

    var agent: Agent
    var agentVC: AgentViewController!
    var cerebro: RedeNeural

    var animations: Animations

    init(window: UIWindow?) {
        self.window = window

        map = Map(square: 10)

        animations = Animations()

        cerebro = RedeNeural()
        animations.redeNeural = cerebro

        let startLocation = Slot(index: Index(col: 1, row: 1))
        agent = Agent(map: map, startLocation: startLocation, cerebro: cerebro)
    }

    func configure() {

        mapVC = MapViewController(map: map)
        mapVC.animations = animations

        agentVC = AgentViewController(agentDS: mapVC, agentSlot: agent.location)
        agentVC.animations = animations

        rootViewController?.removeFromParent()
        rootViewController = ViewController(nibName: viewControllerIdentifier, bundle: nil)

        rootViewController.MapVC = mapVC
        rootViewController.AgentVC = agentVC
        rootViewController.configurator = self
        rootViewController.animations = animations

        agent.delegate = rootViewController
        setDelegates()

        window?.rootViewController = rootViewController
    }


    func reset() {
        animations.reset()
        mapVC.reloadData()
        cerebro.reset()
        agent.reset()
        agentVC.reset()
    }

    func next() {
        let total = agent.agentData.totalPoints
        cerebro.genetic.setarAptidoes(apt: Double(total))
        agent.reset()
        agent.moveToDefaultLocation()
        mapVC.restoreData()
        //setDelegates()
        agent.start()
    }

    func start() {
        agent.start()
    }

    func setDelegates() {
        agent.mapAnimations = mapVC
        agent.movementAnimations = agentVC
    }
}
