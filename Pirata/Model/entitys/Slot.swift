import Foundation

struct Slot: Hashable, Equatable {
    var index: Index
    var type: ImageType = .empty
    private(set) var isBusy: Bool = false

    mutating func setBusy() {
        self.isBusy = true
    }
}
