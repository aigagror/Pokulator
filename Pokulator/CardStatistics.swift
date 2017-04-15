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

    //check if all the cards are filled
    var hasEmpty = false
    for card in cards {
        if card == nil {
            hasEmpty = true
            break
        }
    }
    if !hasEmpty {
        return ret
    }
    
    let curr_hand = getCurrentKnownHand(cards: cards)
    if curr_hand == GenericHand.straightFlush {
        return ret
    }
    for i in GenericHand.straightFlush.rawValue ... curr_hand.rawValue-1 {
        switch GenericHand(rawValue: i)! {
        case GenericHand.onePair:
            ret[GenericHand(rawValue: i)!] = probOnePair(cards: cards)
        default:
            ret[GenericHand(rawValue: i)!] = 0
        }
    }
    return ret
}


// The following probability functions must only be called on cards that have a current worse hand. It is assumed that the hand does not exist yet. It is also assumed that the cards are not filled yet

func probOnePair(cards: [Card?]) -> Double {
    //Assuming all cards are distinct and does not form a straight
    var uniqueRanks = [Int]()
    for card in cards {
        if let c = card {
            uniqueRanks.append(c.value)
        }
    }
    let numberOfCards = uniqueRanks.count
    let freeCards = 7-numberOfCards
    
    
    //get the number of outcomes that a pair matches with one of the current cards
    var pairsWithCurrentCards = 0
    if numberOfCards > 0 {
        let freeKickers = freeCards - 1
        
        //get the valid set of ranks for the free kickers
            //get the number of ways to form straights with the given cards
        let validRankSets = 0

        
        //get the valid set of suits for the free kickers
        let validSuitSets = 0
        
        pairsWithCurrentCards = Binom(n: numberOfCards, choose: 1) * Binom(n: 3, choose: 1) * validRankSets * validSuitSets
    }
    
    //get the number of outcomes that there's a pair not involving the current cards
    var pairsNotWithCurrentCards = 0
    if numberOfCards < 6 {
        let freeKickers = freeCards - 2
        
        //get the valid set of ranks for the free kickers
        //get the number of ways to form straights with the given cards
        let validRankSets = 0
        
        
        //get the valid set of suits for the free kickers
        let validSuitSets = 0
        
        pairsNotWithCurrentCards = Binom(n: 13 - numberOfCards, choose: 1) * Binom(n: 4, choose: 2) * Binom(n: 12 - numberOfCards, choose: 5 - numberOfCards) * pow(Binom(n: 4, choose: 1).toInt(), 5-numberOfCards)
    }
    return (pairsWithCurrentCards + pairsNotWithCurrentCards) / Binom(n: 52-numberOfCards, choose: freeCards)
}

func probTwoPair(cards: [Card?]) -> Double {
    <#function body#>
}

func probThreeOfAKind(cards: [Card?]) -> Double {
    <#function body#>
}

func probStraight(cards: [Card?]) -> Double {
    <#function body#>
}

func probFlush(cards: [Card?]) -> Double {
    <#function body#>
}

func probFullHouse(cards: [Card?]) -> Double {
    <#function body#>
}

func probFourOfAKind(cards: [Card?]) -> Double {
    <#function body#>
}

func probStraightFlush(cards: [Card?]) -> Double {
    <#function body#>
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
