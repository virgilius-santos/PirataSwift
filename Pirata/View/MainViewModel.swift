import Foundation

struct MainService {
    let loadMap: () async -> Map.Region
    let loadPirate: () async -> Slot
    let start: () -> Void
}

final class MainViewModel: ObservableObject {
    @Published var model = MainModel.Model()
    let service: MainService
    
    init(service: MainService) {
        self.service = service
    }
    
    @MainActor
    func set(pirate: Slot) {
        model.pirate = pirate
    }
    
    @MainActor
    func set(modelData: [MainView.DataType]) {
        model.data = modelData
    }
    
    func loadData() async {
        let data = await service.loadMap()
        let modelData = data
            .flatMap({ rows in
                rows.map({ slot in
                    MainModel.DataType(imageType: slot.type, slot: slot)
                })
            })
        await set(modelData: modelData)
        let pirate = await service.loadPirate()
        await set(pirate: pirate)
    }
    
    func execute() {
        service.start()
    }
}

extension MainViewModel: AgentDelegateInfo {
    func update(coins: Int, general: Int, genesis: Int) {
        model.coins = "\(coins)"
        model.total = "\(general)"
        model.generationsNumber = "\(genesis)"
        
    }
    
    func locateCheast(qtd: Int) {
        model.bauStatus = "\(qtd) bau(s)"
    }
    
    func locateDoor(_ status: Bool) {
        model.doorStatus = status ? "Sim" : "Não"
    }
}
