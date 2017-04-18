
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
                for k in j+1...3 {
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

