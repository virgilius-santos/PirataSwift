//
//  AppDelegate.swift
//  Pirata
//
//  Created by Virgilius Santos on 07/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var configurator: Configurator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        window = UIWindow()
        configurator = Configurator()
        window?.rootViewController = configurator.rootViewController

        return true
    }

}

class Configurator {

    let storyboardName = "Main"
    let viewControllerIdentifier = String(describing: ViewController.self)

    var map: Map
    var mapVC: MapViewController

    var rootViewController: ViewController
    var agent: Agent
    var agentVC: AgentViewController

    init() {
        map = Map(square: 10)
        mapVC = MapViewController(map: map)

        let startLocation = Slot(index: Index(col: 1, row: 1))
        agent = Agent(map: map, startLocation: startLocation)
        agentVC = AgentViewController(agent: agent, mapVC: mapVC)

        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        rootViewController = storyboard.instantiateViewController(
            withIdentifier: viewControllerIdentifier) as! ViewController

        rootViewController.MapVC = mapVC
        rootViewController.AgentVC = agentVC
        agent.delegate = rootViewController
        
    }
}
