//
//  Hands.swift
//  Pokulator
//
//  Created by Edward Huang on 4/9/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation

enum Hand: Hashable {
    
    //Includes the royal flush
    case straightFlush(Card)
    
    case fourOfAKind(Card)
    
    //Highest 3 matching cards win
    case fullHouse(Card)
    
    //The player holding the highest ranked card wins. If necessary, the second-highest, third-highest, fourth-highest, and fifth-highest cards can be used to break the tie. If all five cards are the same ranks, the pot is split.
    case flush(Card,Card,Card,Card,Card)
    
    case straight(Card)
    
    case threeOfAKind(Card)
    
    //Highest pair wins. If players have the same highest pair, highest second pair wins. If both players have two identical pairs, highest side card wins.
    case twoPair(Card, Card, Card)
    
    //Highest pair wins. If players have the same pair, the highest side card wins, and if necessary, the second-highest and third-highest side card can be used to break the tie.
    case onePair(Card, Card, Card, Card)
    
    case highCard(Card,Card,Card,Card,Card)
    
    
    // Conforming to the hash protocol
    var hashValue: Int {
        //Hands prime numbers: 53, 59, 61, 67, 71, 73, 79, 83, 89
        
        switch self {
        case .highCard(let c1, let c2, let c3, let c4, let c5):
            return 53 * c1.hashValue * c2.hashValue * c3.hashValue * c4.hashValue * c5.hashValue
        case .onePair(let c1, let c2, let c3, let c4):
            return 59 * c1.hashValue * c2.hashValue * c3.hashValue * c4.hashValue
        case .twoPair(let c1, let c2, let c3):
            return 61 * c1.hashValue * c2.hashValue * c3.hashValue
        case .threeOfAKind(let c1):
            return 67 * c1.hashValue
        case .straight(let c1):
            return 71 * c1.hashValue
        case .flush(let c1, let c2, let c3, let c4, let c5):
            return 73 * c1.hashValue * c2.hashValue * c3.hashValue * c4.hashValue * c5.hashValue
        case .fullHouse(let c1):
            return 79 * c1.hashValue
        case .fourOfAKind(let c1):
            return 83 * c1.hashValue
        case .straight(let c1):
            return 89 * c1.hashValue
        default:
            return 0
        }
    }
    static func ==(lhs: Hand, rhs: Hand) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
