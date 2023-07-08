import SwiftUI

extension MainView {
    struct Model {
        var data: [DataType] = (0..<100).map { _ in DataType() }
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
        var pirate: ImageType?
    }
}

struct MainService {    
    let loadMap: () async -> Map.Region
    let loadPirate: () async -> Slot
}

extension MainView {
    final class ViewModel: ObservableObject {
        @Published var model = Model()
        let service: MainService
        
        init(service: MainService) {
            self.service = service
        }
        
        @MainActor
        func set(modelData: [MainView.DataType]) {
            model.data = modelData
        }
        
        func loadData() async {
            let data = await service.loadMap()
            let pirate = await service.loadPirate()
            let modelData = data
                .flatMap({ rows in
                    rows.map({ slot in
                        DataType(imageType: slot.type, pirate: slot.index == pirate.index ? pirate.type : nil)
                    })
                })
            await set(modelData: modelData)
        }
        
        func execute() {}
    }
}

struct MainView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            GridView(
                numberOfColumns: viewModel.model.numberOfColumns,
                data: viewModel.model.data
            ) { data in
                PeaceView(model: PeaceView.Model.init(imageType: data.imageType, pirate: data.pirate))
                    .aspectRatio(1, contentMode: .fill)
            }
            
            Spacer()
            
            HStack {
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Baus Localizados:")
                        Text(viewModel.model.bauStatus)
                    }
                    HStack {
                        Text("Porta Localizada:")
                        Text(viewModel.model.doorStatus)
                    }
                }
                
                Spacer(minLength: 20)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        Text("Numero de Geraçoes:")
                        Text(viewModel.model.generationsNumber)
                    }
                }
                
                Spacer(minLength: 50)
                
                Button("Executar") {
                    viewModel.execute()
                }
                
                Spacer(minLength: 50)
                
                VStack(alignment: .trailing, spacing: 0) {
                    HStack {
                        Text("Moedas Coletadas:")
                        Text(viewModel.model.coins)
                    }
                    HStack {
                        Text("Pontuação Geral: ")
                        Text(viewModel.model.total)
                    }
                }
            }
            .padding()
            .layoutPriority(2)
        }
        .onAppear {
            Task {
                await viewModel.loadData()
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = Configurator().createViewModel()
        MainView(viewModel: viewModel)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
