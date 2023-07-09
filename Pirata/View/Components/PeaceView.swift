import SwiftUI

struct PeaceView: View {
    struct Model {
        let imageType: ImageType
    }
    
    let model: Model
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.white
            Image("blank")
                .resizable()
            Image(uiImage: model.imageType.image)
                .resizable()
                .padding(10)
//            if let pirate = model.pirate {
//                Image(uiImage: pirate.image)
//                    .resizable()
//                    .padding(20)
//            }
        }
    }
}
