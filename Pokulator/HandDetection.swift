//
//  HandDetection.swift
//  Pokulator
//
//  Created by Edward Huang on 4/12/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation


/// Returns the best known generic hand based on the current state of the FIRST 7 cards
///
/// - Parameter cards: cards known
/// - Returns: current generic hand
func getCurrentKnownHand(cards: Array<Card>) -> Hand {
    
    //get the first 7 cards
    let m = cards.count > 7 ? 7 : cards.count
    let parsedCards = m == 0 ? ArraySlice<Card>() : cards[0...m-1]
    
    if m >= 2 {
        for i in 0...m-2 {
            for j in i+1...m-1 {
                if cards[i] == cards[j] {
                    fatalError("Duplicate cards between indices \(i), \(j)")
                }
            }
        }
    }
    
    var givenRanks = Set<Int>()
    var suitCount = [Suit.clubs:0, Suit.diamonds:0, Suit.hearts:0, Suit.spades:0]
    for card in parsedCards {
        givenRanks.insert(card.value)
        suitCount[card.suit]! += 1
    }
    
    var sortedRanks = givenRanks.sorted()
    if givenRanks.contains(1) {
        sortedRanks.append(14)
    }
    
    //determine if there's a straight
    var straight = 0
    if givenRanks.count >= 5 {
        assert(givenRanks.count <= 7)
        for i in (0...sortedRanks.count - 5).reversed() {
            let x = sortedRanks[i+4]
            if sortedRanks[i]+4 == x && sortedRanks[i+1]+3 == x && sortedRanks[i+2]+2 == x && sortedRanks[i+3]+1 == x  {
                straight = x
            }
        }
    }
    
    //determine if there's a flush
    var flush: Suit? = nil
    for (s,c) in suitCount {
        if c >= 5 {
            flush = s
        }
    }
    
    //determine if there's a straight flush
    if straight != 0 && flush != nil {
        let suit = flush!
        
        var values = Set<Int>()
        for card in parsedCards {
            if card.suit == suit {
                values.insert(card.value)
            }
        }
        assert(values.count >= 5)
        if values.contains(1) {
            values.insert(14)
        }
        let sorted = values.sorted()
        for i in (0...sorted.count - 5).reversed() {
            let x = sorted[i+4]
            if sorted[i]+4 == x && sorted[i+1]+3 == x && sorted[i+2]+2 == x && sorted[i+3]+1 == x  {
                return .straightFlush(x)
            }
        }
    }
    
    // do a values count
    var valuesCount = [Int:Int]()
    for rank in givenRanks {
        valuesCount[rank] = 0
    }
    for card in parsedCards {
        valuesCount[card.value]! += 1
    }
    
    // do multiple values analysis
    var highestPair = 0
    var highestThreeOfAKind = 0
    var highestFourOfAKind = 0
    for (r,y) in valuesCount {
        if y >= 2 {
            highestPair = max(highestPair, r)
            if y >= 3 {
                highestThreeOfAKind = max(highestThreeOfAKind, r)
                if y >= 4 {
                    highestFourOfAKind = max(highestFourOfAKind, r)
                }
            }
        }
    }
    
    //determine if there's a four of a kind
    if highestFourOfAKind != 0 {
        return .fourOfAKind(highestFourOfAKind)
    }
    
    //determine if there's a full house
    if m - givenRanks.count >= 3 && highestThreeOfAKind != 0 {
        var two = false
        for (r,y) in valuesCount {
            if y >= 2 && r != highestThreeOfAKind {
                two = true
            }
        }
        if two {
            return .fullHouse(highestThreeOfAKind)
        }
    }
    
    if let suit = flush {
        var values = Set<Int>()
        for card in parsedCards {
            if card.suit == suit {
                values.insert(card.value)
            }
        }
        assert(values.count >= 5)
        if values.contains(1) {
            values.insert(14)
        }
        let sorted = values.sorted(by: {$0 > $1})
        var t = (0,0,0,0,0)
        if m > 0 {
            t.0 = sorted[0]
            if m > 1 {
                t.1 = sorted[1]
                if m > 2 {
                    t.2 = sorted[2]
                    if m > 3 {
                        t.3 = sorted[3]
                        if m > 4 {
                            t.4 = sorted[4]
                        }
                    }
                }
            }
        }
        return .flush(t.0,t.1,t.2,t.3,t.4)
    }
    
    if straight != 0 {
        return .straight(straight)
    }
    
    //determine if there's a three of a kind
    if highestThreeOfAKind != 0 {
        return .threeOfAKind(highestThreeOfAKind)
    }
    
    //determine if there's a two pair
    if m - givenRanks.count >= 2 && highestPair != 0 {
        var secondHighestPair = 0
        for (r,y) in valuesCount {
            if y >= 2 && r != highestPair {
                secondHighestPair = max(secondHighestPair, r)
            }
        }
        
        var highestOther = 0
        for r in givenRanks {
            if r != highestPair && r != secondHighestPair {
                highestOther = max(highestOther, r)
            }
        }
        
        if secondHighestPair != 0 && highestOther != 0 {
            return .twoPair(highestPair, secondHighestPair, highestOther)
        }
    }
    
    //determine if there's a pair
    if highestPair != 0 {
        //get all values that are not the highestPair
        var values = Array<Int>()
        for card in parsedCards {
            if card.value != highestPair {
                values.append(card.value)
            }
        }
        let sorted = values.sorted(by: {$0 > $1})
        var t = (0,0,0)
        if m > 0 {
            t.0 = sorted[0]
            if m > 1 {
                t.1 = sorted[1]
                if m > 2 {
                    t.2 = sorted[2]
                }
            }
        }
        return .onePair(highestPair,t.0,t.1,t.2)
    } else {
        var values = Array<Int>()
        for card in parsedCards {
            values.append(card.value)
        }
        let sorted = values.sorted(by: {$0 > $1})
        var t = (0,0,0,0,0)
        assert(m == sorted.count)
        if m > 0 {
            t.0 = sorted[0]
            if m > 1 {
                t.1 = sorted[1]
                if m > 2 {
                    t.2 = sorted[2]
                    if m > 3 {
                        t.3 = sorted[3]
                        if m > 4 {
                            t.4 = sorted[4]
                        }
                    }
                }
            }
        }
        
        return .highCard(t.0,t.1,t.2,t.3,t.4)
    }
}

/// Gives the best hand that the opponents have
///
/// - Parameter cards: all of the cards. The first seven are the user's hands and the community cards, the rest are the opponents cardss
/// - Returns: the best hand from all of the opponents
func bestOpponentHand(cards: Array<Card>) -> Hand {
    guard cards.count % 2 == 1 && cards.count > 7 else {
        fatalError("given an odd number of opponent cards or not given all necessary cards")
    }
    
    var communityCards = Array<Card>()
    for card in cards[2...6] {
        communityCards.append(card)
    }
    
    var bestHand = Hand.highCard(0, 0, 0, 0, 0)
    let n = cards.count - 7
    for i in 0...(n/2 - 1) {
        let c1 = cards[7 + 2*i]
        let c2 = cards[8 + 2*i]
        
        var trial = communityCards
        trial.append(c1)
        trial.append(c2)
        
        let hand = getCurrentKnownHand(cards: trial)
        if hand > bestHand {
            bestHand = hand
        }
    }
    
    return bestHand
}
