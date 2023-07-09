import Foundation

extension Agent {
    func switchEvent() {
        mainLoop: while true {
            switch eventoAtual {
            case .start:
                eventoAtual = .checkCurrentPosition
                
            case .checkCurrentPosition:
                analiseCurrentPosition()
                
            case .checkRegion:
                generateNextMovement()
                
            case let .checkMovement(slot, movement):
                checkMovement(slot: slot, movement: movement)
                
            case let .goToSlot(movement):
//                move(movement: movement)
                eventoAtual = .checkCurrentPosition
                
            case .complete:
                updateValues()
                break mainLoop
                
            case .finish:
                break mainLoop
            }
        }
    }
}

private extension Agent {
    func analiseCurrentPosition() {
        let position = agentMap.getSlot(fromIndex: location.index)
        switch position.type {
        case .wall:
            agentData.points += Point.wall
            eventoAtual = .finish

        case .hole:
            agentData.points += Point.hole
            eventoAtual = .finish

        case .bag:
            colectBag(slot: location)
            eventoAtual = .checkRegion
            agentData.points += Point.bag

        case .door:
            agentData.points += Point.door
            eventoAtual = .complete

        case .chest, .blank, .empty, .pirate:
            agentData.points += Point.empty
            eventoAtual = .checkRegion
        }
    }

    func generateNextMovement() {
        let regionList = agentMap.getRegion(fromLocation: location)
        let movement = neuralNet.getMovement(fromSlots: regionList)
        guard let slot = getSlot(fromRegion: regionList, fromMovement: movement) else {
            assertionFailure("impossible movement")
            eventoAtual = .checkRegion
            return
        }

        eventoAtual = .checkMovement(slot, movement)
    }

    func checkMovement(slot: Slot, movement: Movement) {
        switch slot.type {
        case .wall:
            move(movement: movement, newSlot: slot)
            agentData.points += Point.wall
            eventoAtual = .finish

        case .hole where movement.action == .walk:
            move(movement: movement, newSlot: slot)
            agentData.points += Point.hole
            eventoAtual = .finish

        case .hole where movement.action == .jump:
            agentData.points += Point.jumpHole
            eventoAtual = .goToSlot(movement)

        default:
            eventoAtual = .goToSlot(movement)

        }
    }

    func move(movement: Movement, newSlot: Slot) {
        location = newSlot
        switch movement.action {
        case .walk:
            moveView(to: newSlot)
        case .jump:
            jumpView(to: newSlot)
        case .none:
            break
        }
    }

    func getSlot(
        fromRegion regionList: Map.RegionList,
        fromMovement movement: Movement
    ) -> Slot? {

        var rowOffset = 0
        var cowOffset = 0

        switch movement.direction {
        case .left: cowOffset = -1
        case .right: cowOffset = 1
        case .up: rowOffset = -1
        case .down: rowOffset = 1
        case .none: break
        }

        let checkIndex = Index(
            col: location.index.col + cowOffset,
            row: location.index.row + rowOffset
        )
        let slot = regionList.first(where: { $0.index == checkIndex })
        return slot
    }

}
