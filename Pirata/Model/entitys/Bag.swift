//
//  Bag.swift
//  Pirata
//
//  Created by Virgilius Santos on 07/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

struct Bag {
    private(set) var valor: Int
    private(set) var imageType: ImageType = .bag
    var index: Index?
    
    init(valor: Int) {
        self.valor = valor
    }
}
