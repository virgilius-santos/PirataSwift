import SwiftUI
 
struct GridView<D: Hashable, V: View>: View {
    var numberOfColumns: Int
    var data: [D]
    var content: (D) -> V
    
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: numberOfColumns)
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.cyan
            
            GeometryReader { geometry in
                LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(data, id: \.self) { data in
                        content(data)
                    }
                }
                .frame(width: geometry.size.min)
                .padding()
            }
        }
        .background(Color.red)
    }
}

extension CGSize {
    var min: CGFloat {
        height > width ? width : height
    }
}
