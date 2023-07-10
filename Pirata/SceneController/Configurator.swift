import UIKit
import SwiftUI

final class Configurator {
    var window: UIWindow?
    var map: Map
    var agent: Agent!
    var startLocation: Slot

    var brain: NeuralNet
    var genetic: NeuralGenetic
    
    var playing = false
    
    weak var agentDelegateInfo: AgentDelegateInfo?
    weak var agentMapAnimations: AgentMapAnimations?
    weak var agentMovementAnimations: AgentMovementAnimations?

    init(window: UIWindow? = nil) {
        self.window = window
        startLocation = Slot(index: Index(col: 1, row: 1))
        startLocation.type = .pirate

        map = Map(square: 10)

        brain = NeuralNet()

        genetic = NeuralGenetic()
        genetic.popular(weight: brain.qtdWeights)
    }
    
    func createViewModel() -> MainView.ViewModel {
        let service = MainService(
            loadMap: { [unowned map] in
                map.fillMatriz()
                return map.loadData()
            },
            loadPirate: { [unowned self] in self.startLocation },
            start: { [unowned self] in
                if self.playing {
//                    self.reset()
                } else {
                    self.start()
                }
                self.playing.toggle()
            }
        )
        let viewModel = MainView.ViewModel(service: service)
        return viewModel
    }

    func configure() {
        let viewModel = createViewModel()
        agentDelegateInfo = viewModel
        agentMovementAnimations = viewModel
        let rootView = MainView(viewModel: viewModel)
        window?.rootViewController = UIHostingController(rootView: rootView)
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
        
        agent.delegate = agentDelegateInfo
        agent.mapAnimations = agentMapAnimations
        agent.movementAnimations = agentMovementAnimations
        
        let evt = agent.start()
        if case .finish = evt {
            self.next()
        }

        if case .complete = evt, !genetic.canShow {
            self.next()
        }
    }
    
    func next() {
        let total = agent.agentData.totalPoints
        genetic.setarAptidoes(apt: Double(total))

        agent.reset()
        agent.moveToDefaultLocation()
//        mapVC.restoreData()

        start()
    }

//    func reset() {
//        animations.reset()
//        mapVC.reloadData()
//
//        brain.reset()
//        genetic.popular(weight: brain.qtdWeights)
//
//        agent.reset()
//        agentVC.reset()
//    }
}
