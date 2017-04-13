//
//  CardStatistics.swift
//  Pokulator
//
//  Created by Edward Huang on 4/5/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation

/// Gives a summary of how good the hand is
///
/// - Parameter cards: cards that are known so far
/// - Returns: an array of keys of all possible hands along with their probabilities
func cardStatistics(cards: [Card?]) -> [GenericHand : Double] {
    var ret = [GenericHand : Double]()
    let curr_hand = getCurrentKnownHand(cards: cards)
    for i in curr_hand.rawValue+1 ... GenericHand.straightFlush.rawValue {
        ret[GenericHand(rawValue: i)!] = 0
    }
    return ret
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
