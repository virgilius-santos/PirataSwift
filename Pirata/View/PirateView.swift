import SwiftUI

struct PirateView: View {
    let imageType: ImageType = .pirate
    let rect: CGRect
    
    var body: some View {
        Image(uiImage: imageType.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: rect.size.width/2, height: rect.size.height/2)
            .background(Color.yellow)
            .position(
                x: rect.minX+rect.size.width/2,
                y: rect.minY+rect.size.height/4
            )
            .animation(.easeInOut(duration: 1.0), value: rect)
    }
}
