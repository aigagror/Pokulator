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
    if curr_hand == GenericHand.straightFlush {
        return ret
    }
    for i in GenericHand.straightFlush.rawValue ... curr_hand.rawValue-1 {
        switch GenericHand(rawValue: i)! {
        case GenericHand.onePair:
            ret[GenericHand(rawValue: i)!] = probabilityOfOnePair(cards: cards)
        default:
            ret[GenericHand(rawValue: i)!] = 0
        }
    }
    return ret
}


// The following probability functions must only be called on cards that have a current worse hand. It is assumed that the hand does not exist yet

func probabilityOfOnePair(cards: [Card?]) -> Double {
    //Assuming all cards are distinct
    var uniqueValues = [Int]()
    var numberOfCards = 0
    for card in cards {
        if let c = card {
            uniqueValues.append(c.value)
            numberOfCards += 1
        }
    }
    
    //get the number of outcomes that a pair matches with one of the current cards
    var pairsWithCurrentCards = 0
    if numberOfCards > 0 {
        pairsWithCurrentCards = Binom(n: numberOfCards, choose: 1) * Binom(n: 3, choose: 1) * Binom(n: 13 - numberOfCards, choose: 6 - numberOfCards) * pow(Binom(n: 4, choose: 1).toInt(), 6-numberOfCards)
    }
    
    //get the number of outcomes that there's a pair not involving the current cards
    var pairsNotWithCurrentCards = 0
    if numberOfCards < 6 {
        pairsNotWithCurrentCards = Binom(n: 13 - numberOfCards, choose: 1) * Binom(n: 4, choose: 2) * Binom(n: 12 - numberOfCards, choose: 5 - numberOfCards) * pow(Binom(n: 4, choose: 1).toInt(), 5-numberOfCards)
    }
    return (pairsWithCurrentCards + pairsNotWithCurrentCards) / Binom(n: 52-numberOfCards, choose: 7-numberOfCards)
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
