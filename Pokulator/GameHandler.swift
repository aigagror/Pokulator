//
//  GameHandler.swift
//  Pokulator
//
//  Created by Edward Huang on 4/26/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation


/// This queue is used to protect the critical section of all of the fileprivate variables here
public let dataQueue = DispatchQueue(label: "adder", qos: .background)

fileprivate var cards = Array<Card>()

fileprivate var hand_trials = 0
fileprivate var hand_data:[GenericHand:Int] = emptyData

fileprivate var opponents = 0
fileprivate var win_trials = 0
fileprivate var wins = 0


var emptyData: [GenericHand:Int] {
    var emptyData: [GenericHand:Int] = [:]
    for i in 0...8 {
        emptyData[GenericHand(rawValue: i)!] = 0
    }
    return emptyData
}

func getCards() -> Array<Card> {
    return cards
}


/// Performs n sample rounds and updates the hands and wins informations. Blocks until all of the data is updated
///
/// - Parameter n: Number of iterations to make
func monteCarlo(n: Int) {
    let start = Date()
    
    let curr_hand = getCurrentKnownHand(cards: cards)
    
    let group = DispatchGroup()
    
    func addToData(hands: [GenericHand : Int], w: Int, w_trials: Int) {
        for (hand,value) in hands {
            hand_data[hand]! += value
            hand_trials += value
        }
        wins += w
        win_trials += w_trials
    }
    
    
    let monteQueue = DispatchQueue(label: "queuename", attributes: .concurrent)
    
    let size = 10_000
    let k = Int((Double(n)/Double(size)).rounded(.up))
    for _ in 1...k {
        monteQueue.async(group: group) {
            var d = emptyData
            var w = 0
            for _ in 1...size {
                let (filled_cards, opponent_cards) = randomFill()
                let hand = getCurrentKnownHand(cards: filled_cards)
                d[hand]! += 1
                var cc = Array<Card>()
                for i in 2...6 {
                    cc.append(filled_cards[i])
                }
                let best_opponent_hand = bestOpponentHand(community_cards: cc, opponent_cards: opponent_cards)
                if hand.rawValue < best_opponent_hand.rawValue {
                    w += 1
                }
            }
            dataQueue.async(group: group) {
                addToData(hands: d, w: w, w_trials: size)
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
    guard opponent_cards.count % 2 == 0 && community_cards.count == 5 else {
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
        if cards != c {
            dataQueue.sync {
                hand_trials = 0
                hand_data = emptyData
                wins = 0
                win_trials = 0
                cards = c
            }
            print("refreshed hand data")
            print(hand_data)
        }
    }
    if let o = new_opponents {
        if opponents != o {
            dataQueue.sync {
                wins = 0
                win_trials = 0
                opponents = 0
            }
            print("refreshed win data")
        }
    }
}

func getHandData() -> [GenericHand:Int] {
    dataQueue.sync {
        
    }
    dataQueue.suspend()
    let hd = hand_data
    dataQueue.resume()
    return hd
}

func getHandTrials() -> Int {
    dataQueue.sync {
        
    }
    dataQueue.suspend()
    let ht = hand_trials
    dataQueue.resume()
    return ht
}

func getWins() -> Int {
    dataQueue.sync {
        
    }
    dataQueue.suspend()
    let w = wins
    dataQueue.resume()
    return w
}
