//
//  ProbabilityUtilities.swift
//  Pokulator
//
//  Created by Edward Huang on 4/17/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation

///Returns the number of ways can pick the free cards while not forming a flush with the rest of the given cards. Note that cards are distinguishable here, and it is assumed that the cards will choose ranks that have not been chosen yet so all suits will be available for each card
///
/// - Parameter cards: set of cards given
/// - Returns: the number of ways to select the suits of the free cards given that they will be of distinct ranks with themselves and the given cards
func numValidSuitSets(cards: Set<Card>) -> Int {
    var suitCount = [Suit.clubs:0,Suit.diamonds:0,Suit.hearts:0,Suit.spades:0]
    for card in cards {
        suitCount[card.suit]! += 1
    }
    
    let free = 7 - cards.count
    let possibleSuitSets = pow(4, free)
    var sixFlushSets = 0
    for suit in [Suit.clubs,Suit.diamonds,Suit.hearts,Suit.spades] {
        let suitsNeeded = 6 - suitCount[suit]!
        assert(free <= suitsNeeded)
        if free == suitsNeeded {
            sixFlushSets += 1
        }
    }
    
    var fiveFlushSets = 0
    for suit in [Suit.clubs,Suit.diamonds,Suit.hearts,Suit.spades] {
        let suitsNeeded = 5 - suitCount[suit]!
        if free >= suitsNeeded {
            if free == suitsNeeded {
                fiveFlushSets += 1
            } else {
                //we have one left over card
                fiveFlushSets += Binom(n: free, choose: 1) * 3
            }
        }
    }
    let validSuitSets = possibleSuitSets - sixFlushSets - fiveFlushSets
    assert(validSuitSets >= 0)
    return validSuitSets
}


///Returns the number of ways the free cards can pick their ranks while being all distinct and not in a straight with the rest of the given cards. It is assumed that there is a pair in the cards already so that the possibility of a seven-way straight cannot exist
///
/// - Parameter cards: set of cards given
/// - Returns: the number of ways to select the free cards given that they will be of distinct ranks with themselves and the given cards
func numValidRankSets(cards: Set<Card>) -> Int {
    var numberOfCards = cards.count
    let free = 7 - cards.count
    var givenRanks = Set<Int>()
    
    for card in cards {
        givenRanks.insert(card.value)
        if card.value == 1 {
            givenRanks.insert(14)
        }
        numberOfCards += 1
    }
    
    
    let numTakenRanks = 6 - free
    
    //Sets of ranks that are distinct with themselves and the given ranks
    let possibleRankSets = Binom(n: 13 - numTakenRanks, choose: free)
    
    
    var sixStraightSets = 0
    for i in 1...9 {
        var ranksNeeded = 0
        for j in i...i+5 {
            if !givenRanks.contains(j) {
                ranksNeeded += 1
            }
        }
        assert(free <= ranksNeeded)
        if ranksNeeded == free {
            sixStraightSets += 1
        }
    }
    
    var fiveStraightSets = 0
    for i in 1...10 {
        var ranksNeeded = 0
        if i > 1 && givenRanks.contains(i-1) {
            continue
        }
        if i < 10 && givenRanks.contains(i+5) {
            continue
        }
        for j in i...i+4 {
            if !givenRanks.contains(j) {
                ranksNeeded += 1
            }
        }
        if free >= ranksNeeded {
            if free == ranksNeeded {
                fiveStraightSets += 1
            } else {
                //we have one left over card. Figure out how many ranks it can have
                switch i {
                case 1:
                    fiveStraightSets += 7
                case 10:
                    fiveStraightSets += 7
                default:
                    fiveStraightSets += 6
                }
            }
        }
    }
    let validRankSets = possibleRankSets - sixStraightSets - fiveStraightSets
    assert(validRankSets >= 0)
    return validRankSets
}
