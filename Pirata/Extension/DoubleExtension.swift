//
//  DoubleExtension.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

extension Double {

    static var randomDouble: Double {
        let gen = ClosedRange<Double>(uncheckedBounds: (-1, 1))
        let val = Double.random(in: gen)
        return val
    }

}
