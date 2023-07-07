//
//  IntExtension.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/11/18.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

extension Int {
    static func randomNumber(_ data: Int) -> Int {
        let limit: UInt32 = 10000
        let random = Double(Double.random(in: 0..<Double(limit)) / Double(limit))
        let value = random * Double(data)
        let number = Int(value)
        return number
    }
}
