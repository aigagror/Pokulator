//
//  GameHandler.swift
//  Pokulator
//
//  Created by Edward Huang on 4/26/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation

fileprivate var cards = Array<Card>()

fileprivate var hand_trials = 0
fileprivate var hand_data:[GenericHand:Int] = [:]

fileprivate var opponents = 0
fileprivate var win_trials = 0
fileprivate var wins = 0


func getCards() -> Array<Card> {
    return cards
}

/// Performs n sample rounds and updates the hands and wins informations
///
/// - Parameter n: Number of iterations to make
func monteCarlo(n: Int) {
    let start = Date()
    
    let curr_hand = getCurrentKnownHand(cards: cards)
    
    let group = DispatchGroup()
    
    let adderQueue = DispatchQueue(label: "adder")
    func addToHandData(add: [GenericHand : Int]) {
        for (hand,value) in add {
            hand_data[hand]! += value
        }
    }
    
    var emptyRet: [GenericHand:Int] = [:]
    for i in 0...8 {
        emptyRet[GenericHand(rawValue: i)!] = 0
    }
    
    let concurrentQueue = DispatchQueue(label: "queuename", attributes: .concurrent)
    
    let size = 10_000
    let k = Int((Double(n)/Double(size)).rounded(.up))
    for _ in 1...k {
        concurrentQueue.async(group: group) {
            var d = emptyRet
            for _ in 1...size {
                let (filled_cards, opponent_cards) = randomFill()
                let hand = getCurrentKnownHand(cards: filled_cards)
                d[hand]! += 1
                let best_opponent_hand = bestOpponentHand(community_cards: filled_cards[2...6], opponent_cards: opponent_cards)
            }
            adderQueue.async(group: group) {
                addToHandData(add: d)
            }
        }
    }
    
    group.wait()
    
    let elapsed = -start.timeIntervalSinceNow
    print("Took \(elapsed) seconds")
}

fileprivate func randomFill() -> (Array<Card>, Array<Card>) {
    var main_cards = cards
    while main_cards.count < 7 {
        let value = Int(arc4random_uniform(13) + 1)
        let suit = Int(arc4random_uniform(4))
        let new_card = Card(value: value, suit: suit)
        if !main_cards.contains(new_card) {
            main_cards.append(new_card)
        }
    }
    var opponents_cards = Array<Card>()
    while opponents_cards.count < 2*opponents {
        let value = Int(arc4random_uniform(13) + 1)
        let suit = Int(arc4random_uniform(4))
        let card = Card(value: value, suit: suit)
        if !opponents_cards.contains(card) {
            opponents_cards.append(card)
        }
    }
    
    return (main_cards,opponents_cards)
}

fileprivate func bestOpponentHand(community_cards: Array<Card>, opponent_cards: Array<Card>) -> GenericHand {
    guard cards.count % 2 == 0 && community_cards.count == 5 else {
        fatalError("given an odd number of opponent cards")
    }
    
    var bestHand = GenericHand.highCard
    
    return bestHand
}


/// Given the new data about the cards, update the trial information appropriately
///
/// - Parameters:
///   - cards: updated cards
///   - opponents: updated number of opponents
func update(new_cards: Array<Card>? = nil, new_opponents: Int? = nil) -> Void {
    if let c = new_cards {
        cards = c
    }
    if let o = new_opponents {
        opponents = o
    }
}

func getHandData() -> [GenericHand:Int] {
    return hand_data
}

func getHandTrials() -> Int {
    return hand_trials
}

func getWins() -> Int {
    return wins
}
