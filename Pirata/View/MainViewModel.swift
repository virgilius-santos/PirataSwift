import Foundation

struct MainService {
    let loadMap: () async -> Map.Region
    let loadPirate: () async -> Slot
    let start: () async -> Void
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
        Task {
            await service.start()
        }
    }
}

extension MainViewModel: AgentDelegateInfo {
    @MainActor
    func update(coins: Int, general: Int, genesis: Int) {
        model.coins = "\(coins)"
        model.total = "\(general)"
        model.generationsNumber = "\(genesis)"
        
    }
    
    @MainActor
    func locateCheast(qtd: Int) {
        model.bauStatus = "\(qtd) bau(s)"
    }
    
    @MainActor
    func locateDoor(_ status: Bool) {
        model.doorStatus = status ? "Sim" : "Não"
    }
}

extension MainViewModel: AgentMovementAnimations {
    func move(to slot: Slot, speed: Double) {
        DispatchQueue.main.async {
            self.model.pirate?.index = slot.index
        }
    }
    
    func goOut(direction: Orientation, value: Float, speed: Double) {
    }
}
