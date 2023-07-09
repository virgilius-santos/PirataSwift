import SwiftUI

struct MainView: View {
    typealias ViewModel = MainViewModel
    typealias Model = MainModel.Model
    typealias DataType = MainModel.DataType
    
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
                        PirateView(rect: rect)
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
                    withAnimation {
                        viewModel.execute()
                    }
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
