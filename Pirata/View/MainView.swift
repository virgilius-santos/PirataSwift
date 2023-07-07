import SwiftUI

extension MainView {
    final class ViewModel: ObservableObject {
        @Published var model = Model()
        
        func execute() {
            
        }
    }
    
    struct Model {
        var buttonTitle: String = "Executar"
        var bauStatus: String = "0 bau(s)"
        var doorStatus: String = "não"
        var coins: String = "0"
        var total: String = "0"
        var generationsNumber: String = "0"
    }
}

struct MainView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        VStack(spacing: .zero) {
            Rectangle()
                .foregroundColor(Color.blue)
                .layoutPriority(1)
            
            HStack {
                VStack(alignment: .leading, spacing: .zero) {
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
                
                VStack(alignment: .leading, spacing: .zero) {
                    HStack {
                        Text("Numero de Geraçoes:")
                        Text(viewModel.model.generationsNumber)
                    }
                }
                
                Spacer(minLength: 50)
                
                Button(viewModel.model.buttonTitle) {
                    viewModel.execute()
                }
                
                Spacer(minLength: 50)
                
                VStack(alignment: .trailing, spacing: .zero) {
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
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
