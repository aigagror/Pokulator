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
    case straightFlush(Int)
    
    case fourOfAKind(Int)
    
    //Highest 3 matching cards win
    case fullHouse(Int)
    
    //The player holding the highest ranked card wins. If necessary, the second-highest, third-highest, fourth-highest, and fifth-highest cards can be used to break the tie. If all five cards are the same ranks, the pot is split.
    case flush(Int,Int,Int,Int,Int)
    
    case straight(Int)
    
    case threeOfAKind(Int)
    
    //Highest pair wins. If players have the same highest pair, highest second pair wins. If both players have two identical pairs, highest side card wins.
    case twoPair(Int, Int, Int)
    
    //Highest pair wins. If players have the same pair, the highest side card wins, and if necessary, the second-highest and third-highest side card can be used to break the tie.
    case onePair(Int, Int, Int, Int)
    
    case highCard(Int,Int,Int,Int,Int)
    
    // Conforming to the hash protocol
    var hashValue: Int {
        //Hands prime numbers: 53, 59, 61, 67, 71, 73, 79, 83, 89
        
        //Card value prime numbers: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41
        
        let cvp = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41]
        
        
        switch self {
        case .highCard(let c1, let c2, let c3, let c4, let c5):
            return 53 * cvp[c1-1] * cvp[c2-1] * cvp[c3-1] * cvp[c4-1] * cvp[c5-1]
        case .onePair(let c1, let c2, let c3, let c4):
            return 59 * cvp[c1-1] * cvp[c2-1] * cvp[c3-1] * cvp[c4-1]
        case .twoPair(let c1, let c2, let c3):
            return 61 * cvp[c1-1] * cvp[c2-1] * cvp[c3-1]
        case .threeOfAKind(let c1):
            return 67 * cvp[c1-1]
        case .straight(let c1):
            return 71 * cvp[c1-1]
        case .flush(let c1, let c2, let c3, let c4, let c5):
            return 73 * cvp[c1-1] * cvp[c2-1] * cvp[c3-1] * cvp[c4-1] * cvp[c5-1]
        case .fullHouse(let c1):
            return 79 * cvp[c1-1]
        case .fourOfAKind(let c1):
            return 83 * cvp[c1-1]
        case .straightFlush(let c1):
            return 89 * cvp[c1-1]
        default:
            return 0
            print("Error in Hand hash value")
        }
    }
    static func ==(lhs: Hand, rhs: Hand) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

enum GenericHand {
    
    //Includes the royal flush
    case straightFlush
    
    case fourOfAKind
    
    case fullHouse
    
    case flush
    
    case straight
    
    case threeOfAKind
    
    case twoPair
    
    case onePair
    
    case highCard
}
