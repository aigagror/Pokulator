//
//  TwoPair.swift
//  Pokulator
//
//  Created by Edward Huang on 4/16/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation

func probTwoPair(cards: Set<Card>) -> Double {
    assert(cards.count < 7)
    //The cards can contain at most one pair. There cannot be a flush or a straight
    var uniqueRanks = Set<Int>()
    var givenPair:Int? = nil
    for card in cards {
        if uniqueRanks.contains(card.value) {
            givenPair = card.value
        } else {
            uniqueRanks.insert(card.value)
        }
    }
    
    //A two pair could contain three pairs plus a singleton, or two pairs with 3 cards of distinct rank
    
    //The case where there are three pairs plus a singleton
    var numThreePair = 0
    if uniqueRanks.count <= 4 {
        
        switch uniqueRanks.count {
        case 0:
            numThreePair = 2_471_040
        case 1:
            if cards.count == 1 {
                // the given card is not part of the three pairs
                let a = Binom(n: 12, choose: 3) * pow(6, 3)
                
                // the given card is part of the three pairs
                let b = 3 * Binom(n: 12, choose: 2) * pow(6, 2) * 40
                
                numThreePair = a + b
            } else {
                assert(givenPair != nil)
                numThreePair = Binom(n: 12, choose: 2) * pow(6, 2) * 40
            }
            
        case 2:
            if givenPair != nil {
                assert(cards.count == 3)
                // the card that's not part of the given pair is one of the three pairs
                let a = 3 * Binom(n: 11, choose: 1) * 6 * 40
                
                // the card that's not part of the given pair is the singleton
                let b = Binom(n: 11, choose: 2) * pow(6, 2)
                
                numThreePair = a + b
            } else {
                // both of the cards are part of the three pairs
                let a = 3 * 3 * Binom(n: 11, choose: 1) * 40
                
                // one of the cards is a singleton
                let b = 2 * (3 * Binom(n: 11, choose: 2) * pow(6, 2))
                
                numThreePair = a + b
            }
        case 3:
            if givenPair != nil {
                assert(cards.count == 4)
                //both of the singles are part of the three pairs
                let a = 3 * 3 * 40
                
                //one of the singles is the singleton
                let b = 2 * (3 * Binom(n: 10, choose: 1) * 6)
                
                numThreePair = a + b
                
            } else {
                //all cards are part of the three pairs
                let a = 3 * 3 * 3 * 40
                
                //one of them is the singleton
                let b = 3 * (3 * 3 * Binom(n: 10, choose: 1))
                
                numThreePair = a + b
            }
        default:
            //there must be 4 uniquevalues
            assert(uniqueRanks.count == 4)
            if givenPair != nil {
                assert(cards.count == 5)
                //one of the cards is the singleton
                numThreePair = 3 * (3 * 3)
            } else {
                //one of the cards is the singleton
                numThreePair = 4 * (3 * 3 * 3)
            }
        }
    }
    
    
    //The case where there are two pairs with 3 cards of distinct rank
    var numTwoPair = 0
    if uniqueRanks.count <= 5 {
        switch uniqueRanks.count {
        case 0:
            numTwoPair = 28_962_360
        case 1:
            if givenPair != nil {
                assert(cards.count == 2)
            } else {
                
            }
        case 2:
            if givenPair != nil {
                assert(cards.count == 3)
                
            } else {
                
            }
        case 3:
            if givenPair != nil {
                assert(cards.count == 4)
                
            } else {
                
            }
        case 4:
            if givenPair != nil {
                assert(cards.count == 5)
                
            } else {
                
            }
        default:
            if givenPair != nil {
                assert(cards.count == 6)
                
            } else {
                
            }
        }
    }
    
    return (numThreePair + numTwoPair) / Binom(n: 52-cards.count, choose: 7-cards.count)
}
