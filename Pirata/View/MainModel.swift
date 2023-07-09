import Foundation

enum MainModel {
    struct Model {
        var data: [DataType] = []
        var pirate: Slot?
        var bauStatus: String = "0 bau(s)"
        var doorStatus: String = "não"
        var coins: String = "0"
        var total: String = "0"
        var generationsNumber: String = "0"
        
        var numberOfColumns: Int {
            Int(sqrt(Double(data.count)))
        }
    }
    
    struct DataType: Hashable {
        var id = UUID()
        var imageType: ImageType = .empty
        var slot: Slot
    }
}
