import UIKit
import SwiftUI

extension MainService {
    static func live(mapVC: MapViewController, agentVC: AgentViewController) -> MainService {
        MainService(
            loadMap: { mapVC.loadData() },
            loadPirate: { agentVC.agentSlot }
        )
    }
}
final class Configurator {

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

    init(window: UIWindow? = nil) {
        self.window = window

        startLocation = Slot(index: Index(col: 1, row: 1))
        startLocation.type = .pirate

        map = Map(square: 10)

        brain = NeuralNet()

        genetic = NeuralGenetic()
        genetic.popular(weight: brain.qtdWeights)

        animations = Animations(filter: genetic)

    }
    
    func createViewModel() -> MainView.ViewModel {
        mapVC = MapViewController(map: map)
//        mapVC.animations = animations

        agentVC = AgentViewController(agentDS: mapVC, agentSlot: startLocation)
//        agentVC.animations = animations

//        rootViewController?.removeFromParent()
//        rootViewController = ViewController(nibName: viewControllerIdentifier, bundle: nil)
//
//        rootViewController.mapVC = mapVC
//        rootViewController.agentVC = agentVC
//        rootViewController.configurator = self
//        rootViewController.animations = animations
        let viewModel = MainView.ViewModel(service: .live(mapVC: mapVC, agentVC: agentVC) )
        return viewModel
    }

    func configure() {

//        mapVC = MapViewController(map: map)
//        mapVC.animations = animations
//
//        agentVC = AgentViewController(agentDS: mapVC, agentSlot: startLocation)
//        agentVC.animations = animations
//
//        rootViewController?.removeFromParent()
//        rootViewController = ViewController(nibName: viewControllerIdentifier, bundle: nil)
//
//        rootViewController.mapVC = mapVC
//        rootViewController.agentVC = agentVC
//        rootViewController.configurator = self
//        rootViewController.animations = animations
//
//        window?.rootViewController = rootViewController
        let viewModel = createViewModel()
        let rootView = MainView(viewModel: viewModel)
        window?.rootViewController = UIHostingController(rootView: rootView)
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
        agent = Agent(
            map: map,
            startLocation: startLocation,
            brain: brain,
            genesis: genesis
        )
        
        setDelegates()
        
        let evt = agent.start()
        if case .finish = evt {
            self.next()
        }

        if case .complete = evt, !self.genetic.canShow {
            self.next()
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
