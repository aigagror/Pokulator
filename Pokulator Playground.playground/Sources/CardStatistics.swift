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
public func cardStatistics(cards: Set<Card>) -> [GenericHand : Double] {
    var ret = [GenericHand : Double]()

    //check if all the cards are filled
    if cards.count == 7 {
        return ret
    }
    
    return monte_carlo(cards: cards, n: 100_000)
}

public func monte_carlo(cards: Set<Card>, n: Int) -> [GenericHand : Double] {
    var ret = [GenericHand : Double]()
    let curr_hand = getCurrentKnownHand(cards: cards)
    for i in GenericHand.straightFlush.rawValue...curr_hand.rawValue {
        ret[GenericHand(rawValue: i)!] = 0
    }
    let emptyRet = ret

    
    let group = DispatchGroup()
    
    let adderQueue = DispatchQueue(label: "adder")
    func addToRet(add: [GenericHand : Double]) {
        for (hand,value) in add {
            ret[hand]! += value
        }
    }
    
    let concurrentQueue = DispatchQueue(label: "queuename", attributes: .concurrent)
    
    let size = 50_000
    for _ in 1...Int((Double(n)/Double(size)).rounded(.up)) {
        concurrentQueue.async(group: group) {
            var d = emptyRet
            for _ in 1...size {
                let filled_cards = random_fill(cards: cards)
                let hand = getCurrentKnownHand(cards: filled_cards)
                d[hand]! += 1
            }
            adderQueue.async(group: group) {
                addToRet(add: d)
            }
        }
    }
    
    group.wait()
    
    
    for i in GenericHand.straightFlush.rawValue...curr_hand.rawValue {
        ret[GenericHand(rawValue: i)!]! /= Double(n)
    }
    return ret
}



public func random_fill(cards: Set<Card>) -> Set<Card> {
    var cards = cards
    while cards.count < 7 {
        let value = Int(arc4random_uniform(13) + 1)
        let suit = Int(arc4random_uniform(4))
        cards.insert(Card(value: value, suit: suit))
    }
    return cards
}
