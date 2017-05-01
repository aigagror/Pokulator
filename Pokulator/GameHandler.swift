//
//  GameHandler.swift
//  Pokulator
//
//  Created by Edward Huang on 4/26/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation

fileprivate let updateQueue = DispatchQueue(label: "updater")

/// This queue is used to protect the critical section of all of the fileprivate variables here. Any reading/writing on these variables should be done through this queue
fileprivate let dataQueue = DispatchQueue(label: "adder", qos: .background)

fileprivate var cards = Array<Card>()

fileprivate var hand_trials = 0
fileprivate var hand_data:[GenericHand:Int] = emptyData

fileprivate var opponents = 1
fileprivate var win_trials = 0
fileprivate var wins = 0


var emptyData: [GenericHand:Int] {
    var emptyData: [GenericHand:Int] = [:]
    for i in 0...8 {
        emptyData[GenericHand(rawValue: i)!] = 0
    }
    return emptyData
}


/// Given the new data about the cards, update the trial information appropriately
///
/// - Parameters:
///   - cards: updated cards
///   - opponents: updated number of opponents
func update(new_cards: Array<Card>? = nil, new_opponents: Int? = nil) {
    updateQueue.sync {
        updateHelper(new_cards: new_cards, new_opponents: new_opponents)
    }
}

fileprivate func updateHelper(new_cards: Array<Card>? = nil, new_opponents: Int? = nil) -> Void {
    
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
        }
    }
    if let o = new_opponents {
        if opponents != o {
            dataQueue.sync {
                wins = 0
                win_trials = 0
                opponents = o
            }
            print("refreshed win data")
        }
    }
}

/// Performs n sample rounds and updates the hands and wins informations. Blocks until all of the data is updated
///
/// - Parameter n: Number of iterations to make
func monteCarlo(n: Int) {
    updateQueue.sync {
        monteCarloHelper(n: n)
    }
}

fileprivate func monteCarloHelper(n: Int) {
    
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
                let fill = randomFill()
                
                let hand = getCurrentKnownHand(cards: fill)
                d[hand]! += 1
                let best_opponent_hand = bestOpponentHand(cards: fill)
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

fileprivate func randomFill() -> Array<Card> {
    
    var ret = cards
    
    var givenList = Array<Int>()
    for card in cards {
        givenList.append(card.hashValue)
    }
    
    var cardList = Array<Int>()
    for i in 1...52 {
        if !givenList.contains(i) {
            cardList.append(i)
        }
    }
    
    // shuffle the first few cards needed
    let cardsNeeded = (7 - cards.count) + 2 * opponents
    let n = cardList.count
    for i in 0...(cardsNeeded-1) {
        let rand = Int(arc4random_uniform(UInt32(n - i))) + i
        let temp = cardList[i]
        cardList[i] = cardList[rand]
        cardList[rand] = temp
    }
    
    for i in 0...(cardsNeeded-1) {
        ret.append(Card(index: cardList[i]))
    }
        
    return ret
}


/// Gives the best hand that the opponents have
///
/// - Parameter cards: all of the cards. The first seven are the user's hands and the community cards, the rest are the opponents cardss
/// - Returns: the best hand from all of the opponents
fileprivate func bestOpponentHand(cards: Array<Card>) -> GenericHand {
    guard cards.count % 2 == 1 && cards.count > 7 else {
        fatalError("given an odd number of opponent cards or not given all necessary cards")
    }
    
    var bestHand = GenericHand.highCard
    let n = cards.count - 7
    for i in 0...(n/2 - 1) {
        let o1 = cards[7 + 2*i]
        let o2 = cards[8 + 2*i]
        var trial = Array<Card>()
        for i in 2...6 {
            trial.append(cards[i])
        }
        trial.append(o1)
        trial.append(o2)
        let hand = getCurrentKnownHand(cards: trial)
        if hand.rawValue < bestHand.rawValue {
            bestHand = hand
        }
    }
    
    return bestHand
}


func getCards() -> Array<Card> {
    return cards
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

func getWinTrials() -> Int {
    dataQueue.sync {
        
    }
    dataQueue.suspend()
    let w = win_trials
    dataQueue.resume()
    return w
}
