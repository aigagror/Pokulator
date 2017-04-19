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
func cardStatistics(cards: Set<Card>) -> [GenericHand : Int] {
    //check if all the cards are filled
    if cards.count == 7 {
        return [GenericHand : Int]()
    }
    
    return monte_carlo(cards: cards, n: 20_000)
}

func monte_carlo(cards: Set<Card>, n: Int) -> [GenericHand : Int] {
    let start = Date()
    
    var ret = [GenericHand : Int]()
    let curr_hand = getCurrentKnownHand(cards: cards)
    for i in GenericHand.straightFlush.rawValue...curr_hand.rawValue {
        ret[GenericHand(rawValue: i)!] = 0
    }
    let emptyRet = ret
    
    
    let group = DispatchGroup()
    
    let adderQueue = DispatchQueue(label: "adder")
    func addToRet(add: [GenericHand : Int]) {
        for (hand,value) in add {
            ret[hand]! += value
        }
    }
    
    let concurrentQueue = DispatchQueue(label: "queuename", attributes: .concurrent)
    
    let size = 10_000
    let k = Int((Double(n)/Double(size)).rounded(.up))
    for _ in 1...k {
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
    
    let elapsed = -start.timeIntervalSinceNow
    print("Took \(elapsed) seconds")
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
