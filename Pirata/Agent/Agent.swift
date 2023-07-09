import Foundation

protocol AgentMovementAnimations: AnyObject {
    func move(to: Slot, speed: Double)
    func goOut(direction: Orientation, value: Float, speed: Double)
}

protocol AgentMapAnimations: AnyObject {
    func growUp(slot: Slot, speed: Double)
    func getBag(slot: Slot, speed: Double)
}

protocol AgentDelegateInfo: AnyObject {
    func update(coins: Int, general: Int, genesis: Int)
    func locateCheast(qtd: Int)
    func locateDoor(_ status: Bool)
}

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
        get { _eventoAtual }
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

extension Agent {
    func moveView(to: Slot) {
        movementAnimations?.move(to: to, speed: agentData.speed)
    }

    func jumpView(to: Slot) {
        movementAnimations?.move(to: to, speed: agentData.speed/2)
    }

    func goOut(direction: Orientation, value: Float) {
        movementAnimations?.goOut(direction: direction, value: value, speed: agentData.speed)
    }
    
}

extension Agent {
    func growUp(_ slot: Slot) {
        mapAnimations?.growUp(slot: slot, speed: agentData.speed)
    }

    func colectBag(slot: Slot) {
        let bag = agentMap.getBag(slot: slot)
        agentData.bags.append(bag)
        mapAnimations?.getBag(slot: slot, speed: agentData.speed*2)
    }
}

extension Agent {
    func updateValues() {
        let coins = agentData.totalCoins
        let general = agentData.totalPoints
        let genesis = agentData.genesis
        delegate?.update(coins: coins, general: general, genesis: genesis)
    }
    
    func locateCheast() {
        delegate?.locateCheast(qtd: agentData.cheasts.count)
    }
    
    func locateDoor() {
        delegate?.locateDoor(true)
    }
}
