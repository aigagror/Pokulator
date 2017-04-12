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
func cardStatistics(cards: [Card?]) -> [Hand : Double] {
    return [:]
}


/// Returns the best known hand guaranteed based on the current state of the cards
///
/// - Parameter cards: cards known
/// - Returns: current best hand
func getCurrentKnownHand(cards: [Card?]) -> Hand {
    return Hand.fullHouse(0)
}


func hasAStraightFlush(cards: [Card?]) -> Int? {
    //Check if five of the cards are of the same suit
    
    var suitCount = [Suit.clubs : 0, Suit.diamonds : 0, Suit.hearts : 0, Suit.spades : 0]
    
    for card in cards {
        if let c = card {
            suitCount[c.suit]! += 1
        }
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
    var values = [Int]()
    for card in cards {
        if let c = card {
            if c.suit == validSuit {
                values.append(c.value)
                
                //An Ace can be valued at 1 or 14 here
                if c.value == 1 {
                    values.append(14)
                }
            }
        }
    }
    assert(values.count >= 5)
    values.sort()
    for i in (4...values.count - 1).reversed() {
        var isStraight = true
        for j in i-4...i-1 {
            if values[j+1] - values[j] != 1{
                isStraight = false
                break
            }
        }
        if isStraight {
            return values[i] == 14 ? 1 : values[i]
        }
    }
    return nil
}

func hasAFourOfAKind(cards: [Card?]) -> Int? {
    var valuesCount = Array<Int>(repeating: 0, count: 13)
    for card in cards {
        if let c = card {
            valuesCount[c.value-1] += 1
        }
    }
    for i in 0...12 {
        if valuesCount[i] >= 4 {
            return i+1
        }
    }
    return nil
}

func hasAFullHouse(cards: [Card?]) -> Int? {
    var valuesCount = Array<Int>(repeating: 0, count: 13)
    for card in cards {
        if let c = card {
            valuesCount[c.value-1] += 1
        }
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
    }
    
    if has3OfAKind != nil && hasAPair {
        return has3OfAKind
    } else {
        return nil
    }
}

func hasAFlush(cards: [Card?]) -> (Int,Int,Int,Int,Int)? {
    var suitCount = [Suit.clubs : 0, Suit.diamonds : 0, Suit.hearts : 0, Suit.spades : 0]
    for card in cards {
        if let c = card {
            suitCount[c.suit]! += 1
        }
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
        if let c = card {
            if c.suit == validSuit {
                //An Ace is valued at 14 here
                values.append(c.value == 1 ? 14 : c.value)
            }
        }
    }
    
    assert(values.count >= 5)
    
    values.sort(by: {(a,b) in return a > b})
    if values[0] == 14 {
        values[0] = 1
    }
    return (values[0], values[1], values[2], values[3], values[4])
}

func hasAStraight(cards: [Card?]) -> Int? {
    var valuesCount = Array<Int>(repeating: 0, count: 13)
    for card in cards {
        if let c = card {
            valuesCount[c.value-1] += 1
        }
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
            return uniqueValues[i] == 14 ? 1 : uniqueValues[i]
        }
    }
    return nil
}

func hasAThreeOfAKind(cards: [Card?]) -> Int? {
    var valuesCount = Array<Int>(repeating: 0, count: 13)
    for card in cards {
        if let c = card {
            valuesCount[c.value-1] += 1
        }
    }
    
    if valuesCount[0] >= 3 {
        return 1
    }
    for i in (1...12).reversed() {
        if valuesCount[i] >= 3 {
            return i+1
        }
    }
}

func hasATwoPair(cards: [Card?]) -> (Int,Int,Int)? {
    var valuesCount = Array<Int>(repeating: 0, count: 13)
    for card in cards {
        if let c = card {
            valuesCount[c.value-1] += 1
        }
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
    
    if ret.0 != -1 && ret.1 != -1 && ret.2 != -1 {
        return ret
    } else {
        return nil
    }
}

func hasAOnePair(cards: [Card?]) -> Bool {
    var valuesCount = Array<Int>(repeating: 0, count: 13)
    for card in cards {
        if let c = card {
            valuesCount[c.value-1] += 1
        }
    }
    
    var ret = (-1,-1,-1,-1,-1)
    
    if valuesCount[0] >= 2 {
        return 1
    }
    for i in (1...12).reversed() {
        if valuesCount[i] >= 2 {
            return i+1
        }
    }
}


/// Gives the probability that the set of cards will become some version of the hand specified
/// 0 - high card, 8 - straight flush
///
/// - Parameters:
///   - cards: cards known
///   - hand: hand
/// - Returns: probability
func handProbability(cards: [Card?], hand: Int) -> Double {
    assert(cards.count == 7)
    switch hand {
    case 0:
        //high card
        return 1
    case 1:
        //one pair
        for i in 0...cards.count - 2 {
            for j in i+1...cards.count - 1 {
                if let c1 = cards[i], let c2 = cards[j] {
                    if c1.value == c2.value {
                        return 1
                    }
                }
            }
        }
        //cards are distinct. 
        return -1
        
        
        
    default: //straight flush
        return -1
    }
}


func probabilityOfOnePair(cards: [Card?]) -> Double {
    return -1
}

func numberOfKnownCards(cards: [Card?]) -> Int {
    var count = 0
    for card in cards {
        if card != nil {
            count += 1
        } else {
            return count
        }
    }
    return count
}

func differentValues(from cards: [Card?]) -> [Int] {
    var ret = [Int]()
    for i in 1...13 {
        var foundDuplicate = false
        for card in cards {
            if let c = card {
                if c.value == i {
                    foundDuplicate = true
                    break
                }
            }
        }
        if !foundDuplicate {
            ret.append(i)
        }
    }
    return ret
}
