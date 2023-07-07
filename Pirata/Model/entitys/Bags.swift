import Foundation

struct Bags {
    var qtd: Int
    var defaultValue: Int = 200
    var limite: Int = 120
    var data: [Bag] = []
    var totalSet: Int { return defaultValue * qtd}
    
    init(_ qtd: Int) {
        self.qtd = qtd
         makePackage()
    }
    
    mutating func makePackage() {
        for _ in 0 ..< qtd {
            data.append(Bag(valor: self.defaultValue))
        }
        data.append(Bag(valor: self.defaultValue))
    }
}
