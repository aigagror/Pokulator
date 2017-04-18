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
func cardStatistics(cards: Set<Card>) -> [GenericHand : Double] {
    var ret = [GenericHand : Double]()

    //check if all the cards are filled
    if cards.count == 7 {
        return ret
    }
    
    return monte_carlo(cards: cards, n: 100_000)
    
    
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

func monte_carlo(cards: Set<Card>, n: Int) -> [GenericHand : Double] {
    var ret = [GenericHand : Double]()
    let curr_hand = getCurrentKnownHand(cards: cards)
    for i in GenericHand.straightFlush.rawValue...curr_hand.rawValue {
        ret[GenericHand(rawValue: i)!] = 0
    }
    
    for _ in 1...n {
        let filled_cards = random_fill(cards: cards)
        let hand = getCurrentKnownHand(cards: filled_cards)
        ret[hand]! += 1
    }
    
    for i in GenericHand.straightFlush.rawValue...curr_hand.rawValue {
        ret[GenericHand(rawValue: i)!]! /= Double(n)
    }
    return ret
}



func random_fill(cards: Set<Card>) -> Set<Card> {
    var cards = cards
    while cards.count < 7 {
        let value = Int(arc4random_uniform(13) + 1)
        let suit = Int(arc4random_uniform(4))
        cards.insert(Card(value: value, suit: suit))
    }
    return cards
}
