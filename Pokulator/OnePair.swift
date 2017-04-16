//
//  OnePair.swift
//  Pokulator
//
//  Created by Edward Huang on 4/16/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation
func probOnePair(cards: Set<Card>) -> Double {
    //Assuming all cards are distinct and does not form a straight
    var numberOfCards = 0
    var givenRanks = Set<Int>()
    var suitCount = [Suit.clubs:0, Suit.diamonds:0, Suit.hearts:0, Suit.spades:0]
    
    for card in cards {
        if let c = card {
            givenRanks.insert(c.value)
            if c.value == 1 {
                givenRanks.insert(14)
            }
            numberOfCards += 1
            
            suitCount[c.suit]! += 1
        }
    }
    let freeCards = 7-numberOfCards
    
    
    //get the number of outcomes that a pair matches with one of the current cards
    var pairsWithCurrentCards = 0
    if numberOfCards > 0 {
        let freeKickers = freeCards - 1
        
        //get the valid set of ranks for the free kickers
        //get the number of ways to form straights with the given cards
        let possibleRankSets = Binom(n: 13 - numberOfCards, choose: freeKickers)
        var sixStraightSets = 0
        for i in 1...9 {
            var ranksNeeded = 0
            for j in i...i+5 {
                if !givenRanks.contains(j) {
                    ranksNeeded += 1
                }
            }
            assert(freeCards <= ranksNeeded)
            if ranksNeeded == freeCards {
                sixStraightSets += 1
            }
        }
        
        var fiveStraightSets = 0
        for i in 1...10 {
            var ranksNeeded = 0
            for j in i...i+4 {
                if !givenRanks.contains(j) {
                    ranksNeeded += 1
                }
            }
            if freeCards >= ranksNeeded {
                if freeCards == ranksNeeded {
                    fiveStraightSets += 1
                } else {
                    //we have one left over card. Figure out how many ranks it can have
                    var validRanks = 0
                    switch i {
                    case 1:
                        for k in 7...14 {
                            if !givenRanks.contains(k) {
                                validRanks += 1
                            }
                        }
                    case 10:
                        for k in 1...8 {
                            if !givenRanks.contains(k) {
                                validRanks += 1
                            }
                        }
                    case 2:
                        for k in 8...14 {
                            if !givenRanks.contains(k) {
                                validRanks += 1
                            }
                        }
                    case 9:
                        for k in 1...7 {
                            if !givenRanks.contains(k) {
                                validRanks += 1
                            }
                        }
                    default:
                        for k in 1...i-2 {
                            if !givenRanks.contains(k) {
                                validRanks += 1
                            }
                        }
                        for k in i+6...14 {
                            if !givenRanks.contains(k) {
                                validRanks += 1
                            }
                        }
                    }
                    fiveStraightSets += validRanks
                }
            }
        }
        let validRankSets = possibleRankSets - sixStraightSets - fiveStraightSets
        assert(validRankSets >= 0)
        
        
        //get the valid set of suits for the free kickers
        let possibleSuitSets = pow(4, freeKickers)
        var sixFlushSets = 0
        for suit in [Suit.clubs,Suit.diamonds,Suit.hearts,Suit.spades] {
            let suitsNeeded = 6 - suitCount[suit]!
            assert(freeCards <= suitsNeeded)
            if freeCards == suitsNeeded {
                sixFlushSets += 1
            }
        }
        
        var fiveFlushSets = 0
        for suit in [Suit.clubs,Suit.diamonds,Suit.hearts,Suit.spades] {
            let suitsNeeded = 5 - suitCount[suit]!
            if freeCards >= suitsNeeded {
                if freeCards == suitsNeeded {
                    fiveFlushSets += 1
                } else {
                    //we have one left over card
                    fiveFlushSets += 3
                }
            }
        }
        let validSuitSets = possibleSuitSets - sixFlushSets - fiveFlushSets
        assert(validSuitSets >= 0)
        
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

//Returns the number of ways the freekickers can pick their suits while not forming a flush with the rest of the given cards
func numValidSuitSets(freeKickers: Int, suitCount: [Suit: Int]) -> Int {
    let possibleSuitSets = pow(4, freeKickers)
    var sixFlushSets = 0
    for suit in [Suit.clubs,Suit.diamonds,Suit.hearts,Suit.spades] {
        let suitsNeeded = 6 - suitCount[suit]!
        assert(freeKickers <= suitsNeeded)
        if freeCards == suitsNeeded {
            sixFlushSets += 1
        }
    }
    
    var fiveFlushSets = 0
    for suit in [Suit.clubs,Suit.diamonds,Suit.hearts,Suit.spades] {
        let suitsNeeded = 5 - suitCount[suit]!
        if freeCards >= suitsNeeded {
            if freeCards == suitsNeeded {
                fiveFlushSets += 1
            } else {
                //we have one left over card
                fiveFlushSets += 3
            }
        }
    }
    let validSuitSets = possibleSuitSets - sixFlushSets - fiveFlushSets
    assert(validSuitSets >= 0)
}

//Returns the number of ways the freekickers can pick their ranks while being all distinct and not in a straight with the rest of the given cards
func numValidRankSets(cards: [Card?]) -> Int {
    var numberOfCards = 0
    var givenRanks = Set<Int>()
    
    for card in cards {
        if let c = card {
            givenRanks.insert(c.value)
            if c.value == 1 {
                givenRanks.insert(14)
            }
            numberOfCards += 1
        }
    }
    let freeCards = 7-numberOfCards
    
    
    
    let numTakenRanks = 6 - freeKickers
    
    //Sets of ranks that are distinct with themselves and the given ranks
    let possibleRankSets = Binom(n: 13 - numTakenRanks, choose: freeKickers)
    
    
    var sixStraightSets = 0
    for i in 1...9 {
        var ranksNeeded = 0
        for j in i...i+5 {
            if !givenRanks.contains(j) {
                ranksNeeded += 1
            }
        }
        assert(freeKickers <= ranksNeeded)
        if ranksNeeded == numFreeCards {
            sixStraightSets += 1
        }
    }
    
    var fiveStraightSets = 0
    for i in 1...10 {
        var ranksNeeded = 0
        for j in i...i+4 {
            if !givenRanks.contains(j) {
                ranksNeeded += 1
            }
        }
        if freeKickers >= ranksNeeded {
            if freeKickers == ranksNeeded {
                fiveStraightSets += 1
            } else {
                //we have one left over card. Figure out how many ranks it can have
                var validRanks = 0
                switch i {
                case 1:
                    for k in 7...14 {
                        if !givenRanks.contains(k) {
                            validRanks += 1
                        }
                    }
                case 10:
                    for k in 1...8 {
                        if !givenRanks.contains(k) {
                            validRanks += 1
                        }
                    }
                case 2:
                    for k in 8...14 {
                        if !givenRanks.contains(k) {
                            validRanks += 1
                        }
                    }
                case 9:
                    for k in 1...7 {
                        if !givenRanks.contains(k) {
                            validRanks += 1
                        }
                    }
                default:
                    for k in 1...i-2 {
                        if !givenRanks.contains(k) {
                            validRanks += 1
                        }
                    }
                    for k in i+6...14 {
                        if !givenRanks.contains(k) {
                            validRanks += 1
                        }
                    }
                }
                fiveStraightSets += validRanks
            }
        }
    }
    let validRankSets = possibleRankSets - sixStraightSets - fiveStraightSets
    assert(validRankSets >= 0)
    return validRankSets
}
