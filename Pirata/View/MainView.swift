import SwiftUI

extension MainView {
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
                        DataType(imageType: slot.type, slot: slot)
                    })
                })
            await set(modelData: modelData)
            let pirate = await service.loadPirate()
            await set(pirate: pirate)
        }
        
        func execute() {}
    }
}

struct MainView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var imageRect: [Index: CGRect] = [:]
    
    var body: some View {
        VStack(spacing: 0) {
            GridView(
                numberOfColumns: viewModel.model.numberOfColumns,
                data: viewModel.model.data
            ) { data in
                PeaceView(model: PeaceView.Model(imageType: data.imageType))
                    .aspectRatio(1, contentMode: .fill)
                    .readRect { size in
                        imageRect[data.slot.index] = size
                    }
                    
            }
            .overlay(
                Group {
                    if let pirate = viewModel.model.pirate, let rect = imageRect[pirate.index] {
                        Image(uiImage: pirate.type.image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: rect.size.width/2, height: rect.size.height/2)
                            .background(Color.yellow)
                            .position(
                                x: rect.minX+rect.size.width/2,
                                y: rect.minY+rect.size.height/4
                            )
                    }
                }
            )
            
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
