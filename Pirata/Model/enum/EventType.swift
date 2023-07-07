import Foundation

enum EventType {
    case start
    case lookingBags([DataNode], Map.RouteData?)
    case lookingCheastAndDoors([DataNode], Map.RouteData?)
    case goToRoute(Map.RouteData)
    case goToSlot(Slot, Bool)
    case colectBag
    case traveling(Map.RouteData)
    case randomBags([DataNode])
    case completed
    case distributedBags
}

enum EventNeuralType {
    case start
    case checkCurrentPosition
    case checkRegion
    case checkMovement(Slot, Agent.Movement)
    case goToSlot(Agent.Movement)
    case finish
    case complete
}
