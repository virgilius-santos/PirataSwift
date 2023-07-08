import Foundation

final class Agent {
    public typealias Movement = (action: Action, direction: Direction)

    let neuralNet: NeuralNet
    let agentMap: AgentMap

    var agentData: AgentData
    
    weak var delegate: AgentDelegateInfo?
    weak var mapAnimations: AgentMapAnimations?
    weak var movementAnimations: AgentMovementAnimations?

    var location: Slot {
        get { agentData.location }
        set { agentData.location.index = newValue.index }
    }

    var eventoAtual: EventNeuralType {
        get { return _eventoAtual }
        set { _eventoAtual = newValue }
    }
    
    private var _eventoAtual: EventNeuralType
    
    init(map: AgentMap, startLocation location: Slot, brain: NeuralNet, genesis: Int) {
        neuralNet = brain
        agentMap = map

        _eventoAtual = .start

        agentData = AgentData(genesis: genesis)
        agentData.location = location
        agentData.location.type = .pirate
        agentData.defaultLocation = agentData.location
    }

    func start() -> EventNeuralType {
        switchEvent()
        return finished()
    }

    func finished() -> EventNeuralType {
        eventoAtual
    }

    func reset() {
        eventoAtual = .finish
        agentData.clear()
    }

    func moveToDefaultLocation() {
        moveView(to: agentData.defaultLocation)
    }
}
