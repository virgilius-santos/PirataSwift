import Foundation

protocol AgentMovementAnimations: AnyObject {
    func move(to: Slot, speed: Double)
    func goOut(direction: Orientation, value: Float, speed: Double)
}

protocol AgentMapAnimations: AnyObject {
    func growUp(slot: Slot, speed: Double)
    func getBag(slot: Slot, speed: Double)
}

extension Agent {

    func moveView(to: Slot) {
        self.movementAnimations?.move(to: to, speed: agentData.speed)
    }

    func jumpView(to: Slot) {
        self.movementAnimations?.move(to: to, speed: agentData.speed/2)
    }

    func goOut(direction: Orientation, value: Float) {
        self.movementAnimations?
            .goOut(direction: direction, value: value, speed: agentData.speed)
    }
    
}

extension Agent {

    func growUp(_ slot: Slot) {
        self.mapAnimations?.growUp(slot: slot, speed: agentData.speed)
    }

    func colectBag(slot: Slot) {

        let bag = agentMap.getBag(slot: slot)
        agentData.bags.append(bag)
        self.mapAnimations?.getBag(slot: slot, speed: agentData.speed*2)

    }
}
