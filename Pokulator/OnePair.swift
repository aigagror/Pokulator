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
    assert(cards.count < 7)
    
    //get the number of outcomes that a pair matches with one of the current cards
    var pairsWithCurrentCards = 0
    if cards.count > 0 {
        let master_card = cards.first!
        let master_pair = Card(value: master_card.value, suit: (Card.suitToIndex(suit: master_card.suit) + 1) % 4)
        assert(!cards.contains(master_pair))
        
        var cardsWithMasterPair = cards
        cardsWithMasterPair.insert(master_pair)
        
        let validRankSets = numValidRankSets(cards: cardsWithMasterPair)
        
        var validSuitSets = 0
        for i in 0...3 {
            let pair = Card(value: master_card.value, suit: i)
            if cards.contains(pair) {
                continue
            }
            var cardsWithPair = cards
            cardsWithPair.insert(pair)
            validSuitSets += numValidSuitSets(cards: cardsWithPair)
        }
        pairsWithCurrentCards += Binom(n: cards.count, choose: 1) * validRankSets * validSuitSets
    }
    
    //get the number of outcomes that there's a pair not involving the current cards
    var pairsNotWithCurrentCards = 0
    if cards.count < 6 {
        for i in 1...13 {
            //check if there's a given card with rank i
            var rankExists = false
            for card in cards {
                if card.value == i {
                    rankExists = true
                    break
                }
            }
            if rankExists {
                continue
            }
            
            let master_card1 = Card(value: i, suit: .clubs)
            let master_card2 = Card(value: i, suit: .diamonds)
            assert(!cards.contains(master_card1))
            assert(!cards.contains(master_card2))
            
            var cardsWithMasterPair = cards
            cardsWithMasterPair.insert(master_card1)
            cardsWithMasterPair.insert(master_card2)
            let validRankSets = numValidRankSets(cards: cardsWithMasterPair)
            
            
            var validSuitSets = 0
            for j in 0...2 {
                for k in i+1...3 {
                    let card1 = Card(value: i, suit: j)
                    let card2 = Card(value: i, suit: k)
                    assert(!cards.contains(card1))
                    assert(!cards.contains(card2))
                    
                    var cardsWithPair = cards
                    cardsWithPair.insert(card1)
                    cardsWithPair.insert(card2)
                    validSuitSets += numValidSuitSets(cards: cardsWithPair)
                }
            }
            pairsNotWithCurrentCards += validRankSets * validSuitSets
        }
    }
    return (pairsWithCurrentCards + pairsNotWithCurrentCards) / Binom(n: 52-cards.count, choose: 7-cards.count)
}

//Returns the number of ways the freekickers can pick their suits while not forming a flush with the rest of the given cards
func numValidSuitSets(cards: Set<Card>) -> Int {
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
func numValidRankSets(cards: Set<Card>) -> Int {
    var numberOfCards = 0
    var givenRanks = Set<Int>()
    
    for card in cards {
        givenRanks.insert(card.value)
        if card.value == 1 {
            givenRanks.insert(14)
        }
        numberOfCards += 1
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
