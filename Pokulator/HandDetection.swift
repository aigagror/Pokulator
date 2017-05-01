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
func getCurrentKnownHand(cards: Array<Card>) -> GenericHand {
    
    //get the first 7 cards
    let m = cards.count > 7 ? 7 : cards.count
    var parsedCards = Array<Card>()
    if m > 0 {
        for i in 0...(m-1) {
            parsedCards.append(cards[i])
        }
    }
    
    let n = parsedCards.count
    if n >= 2 {
        for i in 0...n-2 {
            for j in i+1...n-1 {
                if parsedCards[i] == parsedCards[j] {
                    fatalError("Duplicate cards")
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
    
    //determine if there's a straight
    var straight = false
    if givenRanks.count >= 5 {
        assert(givenRanks.count <= 7)
        var sorted = givenRanks.sorted()
        if givenRanks.contains(1) {
            sorted.append(14)
        }
        for i in 0...sorted.count - 5 {
            let x = sorted[i+4]
            if sorted[i]+4 == x && sorted[i+1]+3 == x && sorted[i+2]+2 == x && sorted[i+3]+1 == x  {
                straight = true
            }
        }
    }
    
    //determine if there's a flush
    var flush = false
    for (_,c) in suitCount {
        if c >= 5 {
            flush = true
        }
    }
    
    //determine if there's a straight flush
    if straight && flush {
        var getSuit:Suit? = nil
        for (s,c) in suitCount {
            if c >= 5 {
                getSuit = s
                break
            }
        }
        guard getSuit != nil else {
            fatalError("Couldn't get suit for flush")
        }
        let suit = getSuit!
        
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
        for i in 0...sorted.count - 5 {
            let x = sorted[i+4]
            if sorted[i]+4 == x && sorted[i+1]+3 == x && sorted[i+2]+2 == x && sorted[i+3]+1 == x  {
                return .straightFlush
            }
        }
    }
    
    //determine if there's a four of a kind
    if parsedCards.count - givenRanks.count >= 3 {
        var valuesCount = [Int:Int]()
        for rank in givenRanks {
            valuesCount[rank] = 0
        }
        
        for card in parsedCards {
            valuesCount[card.value]! += 1
        }
        
        for (_,y) in valuesCount {
            if y >= 4 {
                return .fourOfAKind
            }
        }
    }
    
    //determine if there's a full house
    if parsedCards.count - givenRanks.count >= 3 {
        var valuesCount = [Int:Int]()
        for rank in givenRanks {
            valuesCount[rank] = 0
        }
        
        for card in parsedCards {
            valuesCount[card.value]! += 1
        }
        
        var three = false
        var two = false
        
        for (_,y) in valuesCount {
            if y >= 3 {
                if three {
                    return .fullHouse
                } else {
                    three = true
                }
            } else if y >= 2 {
                two = true
            }
        }
        if two && three {
            return .fullHouse
        }
    }
    
    if flush {
        return .flush
    }
    
    if straight {
        return .straight
    }
    
    //determine if there's a three of a kind
    if parsedCards.count - givenRanks.count >= 2 {
        var valuesCount = [Int:Int]()
        for rank in givenRanks {
            valuesCount[rank] = 0
        }
        
        for card in parsedCards {
            valuesCount[card.value]! += 1
        }
        
        for (_,y) in valuesCount {
            if y >= 3 {
                return .threeOfAKind
            }
        }
    }
    
    //determine if there's a two pair
    if parsedCards.count - givenRanks.count >= 2 {
        return .twoPair
    }
    
    //determine if there's a pair
    if parsedCards.count - givenRanks.count >= 1 {
        return .onePair
    } else {
        return .highCard
    }
}

/// Returns the hand of the cards
///
/// - Parameter cards: all seven cards
/// - Returns: the hand
func getHand(cards: Set<Card>) -> Hand {
    guard cards.count == 7 else {
        fatalError("Not passing in enough cards")
    }
    if let sf = hasAStraightFlush(cards: cards) {
        return sf
    } else if let fk = hasAFourOfAKind(cards: cards) {
        return fk
    } else if let fh = hasAFullHouse(cards: cards) {
        return fh
    } else if let fl = hasAFlush(cards: cards) {
        return fl
    } else if let st = hasAStraight(cards: cards) {
        return st
    } else if let tk = hasAThreeOfAKind(cards: cards) {
        return tk
    } else if let tp = hasATwoPair(cards: cards) {
        return tp
    } else if let op = hasAOnePair(cards: cards) {
        return op
    } else {
        return getHighCard(cards: cards)
    }
}


func hasAStraightFlush(cards: Set<Card>) -> Hand? {
    //Check if five of the cards are of the same suit
    
    var suitCount = [Suit.clubs : 0, Suit.diamonds : 0, Suit.hearts : 0, Suit.spades : 0]
    
    for card in cards {
        suitCount[card.suit]! += 1
    }
    
    var possibleSuit: Suit? = nil
    for (suit, count) in suitCount {
        if count >= 5 {
            possibleSuit = suit
        }
    }
    
    if possibleSuit == nil {
        return nil
    }
    let validSuit = possibleSuit!
    
    //Check if those five cards are a straight
    var values = Set<Int>()
    for card in cards {
        if card.suit == validSuit {
            values.insert(card.value)
            
            //An Ace can be valued at 1 or 14 here
            if card.value == 1 {
                values.insert(14)
            }
        }
    }
    assert(values.count >= 5)
    for i in (1...10).reversed() {
        var isAStraight = true
        for j in i...i+4 {
            if !values.contains(j) {
                isAStraight = false
                break
            }
        }
        if isAStraight {
            return Hand.straightFlush(i+4 == 14 ? 1 : i+4)
        }
    }
    return nil
}

func hasAFourOfAKind(cards: Set<Card>) -> Hand? {
    var valuesCount = Array<Int>(repeating: 0, count: 13)
    for card in cards {
        valuesCount[card.value-1] += 1
    }
    for i in 0...12 {
        if valuesCount[i] >= 4 {
            return Hand.fourOfAKind(i+1)
        }
    }
    return nil
}

func hasAFullHouse(cards: Set<Card>) -> Hand? {
    var valuesCount = Array<Int>(repeating: 0, count: 13)
    for card in cards {
        valuesCount[card.value-1] += 1
    }
    var has3OfAKind: Int? = nil
    var hasAPair = false
    
    for i in 0...12 {
        if valuesCount[i] >= 3 {
            if i == 0 { // can't be any better than that
                has3OfAKind = i+1
                break
            }
            if let prev3OfAKind = has3OfAKind {
                if i+1 > prev3OfAKind {
                    has3OfAKind = i+1
                }
            } else {
                has3OfAKind = i+1
            }
        }
    }
    
    if let threeOfAKind = has3OfAKind {
        for i in 0...12 {
            if valuesCount[i] >= 2 {
                if i+1 != threeOfAKind {
                    hasAPair = true
                }
            }
        }
        
        if hasAPair {
            return Hand.fullHouse(threeOfAKind)
        }
        
    }
    return nil
}

func hasAFlush(cards: Set<Card>) -> Hand? {
    var suitCount = [Suit.clubs : 0, Suit.diamonds : 0, Suit.hearts : 0, Suit.spades : 0]
    for card in cards {
        suitCount[card.suit]! += 1
    }
    
    var possibleSuit: Suit? = nil
    for (suit, count) in suitCount {
        if count >= 5 {
            possibleSuit = suit
        }
    }
    
    if possibleSuit == nil {
        return nil
    }
    let validSuit = possibleSuit!
    
    var values = [Int]()
    for card in cards {
        if card.suit == validSuit {
            //An Ace is valued at 14 here
            values.append(card.value == 1 ? 14 : card.value)
        }
    }
    
    assert(values.count >= 5)
    
    values.sort(by: {(a,b) in return a > b})
    if values[0] == 14 {
        values[0] = 1
    }
    return Hand.flush(values[0], values[1], values[2], values[3], values[4])
}

func hasAStraight(cards: Set<Card>) -> Hand? {
    var valuesCount = Array<Int>(repeating: 0, count: 13)
    for card in cards {
        valuesCount[card.value-1] += 1
    }
    
    var uniqueValues = [Int]()
    for i in 0...12 {
        if valuesCount[i] > 0 {
            uniqueValues.append(i+1)
            if i == 0 {
                uniqueValues.append(14)
            }
        }
    }
    if uniqueValues.count < 5 {
        return nil
    }
    uniqueValues.sort()
    for i in (4...uniqueValues.count - 1).reversed() {
        var isStraight = true
        for j in i-4...i-1 {
            if uniqueValues[j+1] - uniqueValues[j] != 1{
                isStraight = false
                break
            }
        }
        if isStraight {
            return Hand.straight(uniqueValues[i] == 14 ? 1 : uniqueValues[i])
        }
    }
    return nil
}

func hasAThreeOfAKind(cards: Set<Card>) -> Hand? {
    var valuesCount = Array<Int>(repeating: 0, count: 13)
    for card in cards {
        valuesCount[card.value-1] += 1
    }
    
    if valuesCount[0] >= 3 {
        return Hand.threeOfAKind(1)
    }
    for i in (1...12).reversed() {
        if valuesCount[i] >= 3 {
            return Hand.threeOfAKind(i+1)
        }
    }
    return nil
}

func hasATwoPair(cards: Set<Card>) -> Hand? {
    var valuesCount = Array<Int>(repeating: 0, count: 13)
    for card in cards {
        valuesCount[card.value-1] += 1
    }
    
    var ret = (-1,-1,-1)
    
    if valuesCount[0] >= 2 {
        ret.0 = 1
    }
    for i in (1...12).reversed() {
        if valuesCount[i] >= 2 {
            if ret.0 == -1 {
                ret.0 = i+1
            } else if ret.1 == -1 {
                ret.1 = i+1
            }
        } else if valuesCount[i] >= 1 {
            if ret.2 == -1 {
                ret.2 = i+1
            }
        }
    }
    if ret.2 == -1 {
        ret.2 = 2
    }
    if ret.0 != -1 && ret.1 != -1 {
        return Hand.twoPair(ret.0,ret.1,ret.2)
    } else {
        return nil
    }
}

func hasAOnePair(cards: Set<Card>) -> Hand? {
    var valuesCount = Array<Int>(repeating: 0, count: 13)
    for card in cards {
        valuesCount[card.value-1] += 1
    }
    
    var ret = (-1,-1,-1,-1)
    
    if valuesCount[0] >= 2 {
        ret.0 = 1
    }
    for i in (1...12).reversed() {
        if valuesCount[i] >= 2 && ret.0 == -1{
            ret.0 = i+1
            break
        }
    }
    if ret.0 == -1 { // did not find a pair
        return nil
    }
    for i in (1...12).reversed() {
        if valuesCount[i] > 0 && i+1 != ret.0 {
            if ret.1 == -1 {
                ret.1 = i+1
            } else if ret.2 == -1 {
                ret.2 = i+1
            } else if ret.3 == -1 {
                ret.3 = i+1
                break
            }
        }
    }
    if ret.1 == -1 {
        ret.1 = 2
    }
    if ret.2 == -1 {
        ret.2 = 2
    }
    if ret.3 == -1 {
        ret.3 = 2
    }
    return Hand.onePair(ret.0, ret.1, ret.2, ret.3)
}


/// Assume the cards do not form any better hand
///
/// - Parameter cards: Set of given cards
/// - Returns: high card hand
func getHighCard(cards: Set<Card>) -> Hand {
    var values = [Int]()
    for card in cards {
        values.append(card.value == 1 ? 14 : card.value)
    }
    
    values.sort(by: {$0 > $1})
    while values.count < 5 {
        values.append(2)
    }
    return Hand.highCard(values[0], values[1], values[2], values[3],  values[4])
}
