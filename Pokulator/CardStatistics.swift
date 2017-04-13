//
//  CardStatistics.swift
//  Pokulator
//
//  Created by Edward Huang on 4/5/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation

/// Gives the probability that the set of cards will become some version of the hand specified
/// 0 - high card, 8 - straight flush
///
/// - Parameters:
///   - cards: cards known
///   - hand: hand
/// - Returns: probability
func handProbability(cards: [Card?], hand: Int) -> Double {
    assert(cards.count == 7)
    switch hand {
    case 0:
        //high card
        return 1
    case 1:
        //one pair
        for i in 0...cards.count - 2 {
            for j in i+1...cards.count - 1 {
                if let c1 = cards[i], let c2 = cards[j] {
                    if c1.value == c2.value {
                        return 1
                    }
                }
            }
        }
        //cards are distinct. 
        return -1
        
        
        
    default: //straight flush
        return -1
    }
}


func probabilityOfOnePair(cards: [Card?]) -> Double {
    return -1
}

func numberOfKnownCards(cards: [Card?]) -> Int {
    var count = 0
    for card in cards {
        if card != nil {
            count += 1
        } else {
            return count
        }
    }
    return count
}

func differentValues(from cards: [Card?]) -> [Int] {
    var ret = [Int]()
    for i in 1...13 {
        var foundDuplicate = false
        for card in cards {
            if let c = card {
                if c.value == i {
                    foundDuplicate = true
                    break
                }
            }
        }
        if !foundDuplicate {
            ret.append(i)
        }
    }
    return ret
}
