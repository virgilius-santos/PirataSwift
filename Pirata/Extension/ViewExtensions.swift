import SwiftUI

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(
                        key: SizePreferenceKey.self,
                        value: proxy.size
                    )
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

extension View {
    func readRect(onChange: @escaping (CGRect) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .preference(
                        key: RectPreferenceKey.self,
                        value: proxy.frame(in: .global)
                    )
            }
        )
        .onPreferenceChange(RectPreferenceKey.self, perform: onChange)
    }
}

struct RectPreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
