import Foundation

protocol AgentMap: AnyObject {
    var matrizSize: Int { get }
    var cheastNumbers: Int { get }
    var sideWallPosition: Direction { get }
    var totalSet: Int { get }

    func getRegion(fromLocation location: Slot) -> Map.RegionList

    func getRoute(from: Slot, to: Slot, excludeRole: Bool) -> Map.Route

    func getBag(slot: Slot) -> Bag

    func getSlot(fromIndex index: Index) -> Slot

    func getSlot(fromIndex: Index, withMovement movement: Agent.Movement) -> Slot?
}
