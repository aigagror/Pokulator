//
//  GameHandler.swift
//  Pokulator
//
//  Created by Edward Huang on 4/26/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation


var statsDelegate: StatsDelegate? = nil


var isCalculating = false

//background calculations
let calculatorQueue = DispatchQueue(label: "calculator_queue", qos: DispatchQoS.default)


func startCalculating() -> Void {
    if !isCalculating {
        isCalculating = true
        // Start up the calculations
        calculatorQueue.async {
            var hand_trials = 0
            var win_trials = 0
            
            while hand_trials < 100_000 || win_trials < 100_000 {
                monteCarlo(n: 2_000)
                
                var new_data = [GenericHand:Double]()
                
                let hand_data = getHandData()
                hand_trials = getHandTrials()
                let wins = getWins()
                win_trials = getWinTrials()
                let winPercentage = Double(wins*100) / Double(win_trials)
                
                for (hand,n) in hand_data {
                    new_data[hand] = Double(n*100) / Double(hand_trials)
                }
                
                
                if let statsDelegate = statsDelegate {
                    DispatchQueue.main.sync {
                        statsDelegate.updateStats(handData: new_data, win: winPercentage)
                    }
                }
                
            }
            
            isCalculating = false
        }
    }
    
    
}







fileprivate let updateQueue = DispatchQueue(label: "updater")

/// This queue is used to protect the critical section of all of the fileprivate variables here. Any reading/writing on these variables should be done through this queue
fileprivate let dataQueue = DispatchQueue(label: "adder", qos: .background)

let deckCond = NSCondition()
fileprivate var deck = Array<Card>(arrayLiteral: Card(index: 1), Card(index: 2), Card(index: 3), Card(index: 4), Card(index: 5), Card(index: 6), Card(index: 7), Card(index: 8), Card(index: 9), Card(index: 10), Card(index: 11), Card(index: 12), Card(index: 13), Card(index: 14), Card(index: 15), Card(index: 16), Card(index: 17), Card(index: 18), Card(index: 19), Card(index: 20), Card(index: 21), Card(index: 22), Card(index: 23), Card(index: 24), Card(index: 25), Card(index: 26), Card(index: 27), Card(index: 28), Card(index: 29), Card(index: 30), Card(index: 31), Card(index: 32), Card(index: 33), Card(index: 34), Card(index: 35), Card(index: 36), Card(index: 37), Card(index: 38), Card(index: 39), Card(index: 40), Card(index: 41), Card(index: 42), Card(index: 43), Card(index: 44), Card(index: 45), Card(index: 46), Card(index: 47), Card(index: 48), Card(index: 49), Card(index: 50), Card(index: 51), Card(index: 52))
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
    
    
    startCalculating()

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
    
    let size = 1_000
    let k = Int((Double(n)/Double(size)).rounded(.up))
    for _ in 1...k {
        monteQueue.async(group: group) {
            var d = emptyData
            var w = 0
            for _ in 1...size {
                let fill = randomFill()
                
                let hand = getCurrentKnownHand(cards: fill)
                let genHand = getGeneric(hand)
                d[genHand]! += 1
                let best_opponent_hand = bestOpponentHand(cards: fill)
                if hand >= best_opponent_hand {
                    w += 1
                } else {
                    
                }
            }
            dataQueue.async(group: group) {
                addToData(hands: d, w: w, w_trials: size)
            }
        }
    }
    
    group.wait()
    
}

/// Creates an array where the first 2 are the players hands, the next 5 are the community cards, and the rest are the opponents cards
///
/// - Returns: Array of the cards
fileprivate func randomFill() -> Array<Card> {
    deckCond.lock()
    
    // shuffle the length of the cards about to be returned plus the amount of cards we already have to ensure enough shuffled cards
    var cardsNeeded = (7 - cards.count) + 2 * opponents
    let shuffleAmount = cardsNeeded + cards.count
    for i in 0...(shuffleAmount-1) {
        let rand = Int(arc4random_uniform(UInt32(52 - i))) + i
        let temp = deck[i]
        deck[i] = deck[rand]
        deck[rand] = temp
    }
    
    var ret = cards
    var i = 0
    while cardsNeeded > 0 {
        if !cards.contains(deck[i]) {
            ret.append(deck[i])
            cardsNeeded -= 1
        }
        i += 1
    }
    deckCond.unlock()
    return ret
}





/// Returns the round that we're on
///
/// - Returns:
func getRound() -> Round {
    let count = cards.count
    if count >= 6 {
        return .river
    } else if count >= 5 {
        return .turn
    } else if count >= 2 {
        return .flop
    } else {
        return .hand
    }
}

func getCards() -> Array<Card> {
    return cards
}

func getCards(fromRound: Round) -> Array<Card> {
    let count = cards.count
    
    switch fromRound {
    case .hand:
        if count >= 2 {
            return [cards[0], cards[1]]
        } else {
            return []
        }
        
    case .flop:
        if count >= 5 {
            return [cards[2],cards[3],cards[4]]
        } else {
            return []
        }
    case .turn:
        if count >= 6 {
            return [cards[5]]
        } else {
            return []
        }
    default:
        if count >= 7 {
            return [cards[6]]
        } else {
            return []
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

func getWinTrials() -> Int {
    dataQueue.sync {
        
    }
    dataQueue.suspend()
    let w = win_trials
    dataQueue.resume()
    return w
}
