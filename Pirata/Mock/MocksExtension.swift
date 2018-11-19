//
//  MocksExtension.swift
//  Pirata
//
//  Created by Virgilius Santos on 18/09/2018.
//  Copyright © 2018 Virgilius Santos. All rights reserved.
//

import Foundation

var mock: Bool { return false }


var indice = -1
var nextAction: Agent.Movement {
    indice += 1
    if indice == actions.count {
        indice = 0
    }
    return actions[indice]
}
extension Map {


    
    var mockCheast: [Int] { return [9,8,7,6,5,4,3,2]}
    
    var mockDir: [Orientation?] { return [.vertical, .vertical, .vertical, .vertical] }
    var mockCol: [Int] { return [4, 5, 6, 7] }
    var mockRow: [Int] { return [1, 1, 1, 1] }
    
    func mockHole(_ data: [Slot], aux: Int) -> Int {
        let mockCol = [5,5,4,5,5]
        let mockRow = [4,6,9,8,0]
        let index = data.index(where: { (slot) -> Bool in
            return (slot.index.col == mockCol[aux] && slot.index.row == mockRow[aux])
        }) ?? 0
        print("\(#function) - completo")
        return index
        
    }
    
    var mockBagsIndex: [Int] { return [0,1,2,3,4,5,6,7,8,
                                       9,10,11,12,13,14,15] }
    func mockBags(_ empty: [Slot]) -> [Slot] {
        let mocksEmptys = [empty.first(where: {$0.index.col==7 && $0.index.row==9}), //1
            empty.first(where: {$0.index.col==8 && $0.index.row==9}), //2
            empty.first(where: {$0.index.col==8 && $0.index.row==8}), //3
            empty.first(where: {$0.index.col==8 && $0.index.row==7}), //4
            empty.first(where: {$0.index.col==8 && $0.index.row==6}), //5
            empty.first(where: {$0.index.col==8 && $0.index.row==5}), //6
            empty.first(where: {$0.index.col==8 && $0.index.row==4}), //7
            empty.first(where: {$0.index.col==8 && $0.index.row==3}), //8
            empty.first(where: {$0.index.col==8 && $0.index.row==2}), //9
            empty.first(where: {$0.index.col==8 && $0.index.row==1}), //10
            empty.first(where: {$0.index.col==6 && $0.index.row==9}), //11
            empty.first(where: {$0.index.col==9 && $0.index.row==0}), //12
            empty.first(where: {$0.index.col==9 && $0.index.row==1}), //13
            empty.first(where: {$0.index.col==9 && $0.index.row==2}), //14
            empty.first(where: {$0.index.col==9 && $0.index.row==3}), //15
            empty.first(where: {$0.index.col==9 && $0.index.row==4})] //16
        
        return mocksEmptys.compactMap({$0})
    }
    
    
}
