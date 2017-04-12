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
            return values[i]
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
    var hasAPair: Int? = nil
    for i in 0...12 {
        if valuesCount[i] >= 3 {
            if has3OfAKind != nil {
                if i+1 > has3OfAKind! {
                    hasAPair = has3OfAKind
                    has3OfAKind = i+1
                } else {
                    hasAPair = i+1
                }
            } else {
                has3OfAKind = i+1
            }
        } else if valuesCount[i] >= 2 {
            hasAPair = i+1
        }
    }
    if has3OfAKind != nil && hasAPair != nil {
        return has3OfAKind
    } else {
        return nil
    }
}

//func hasAFlush(cards: [Card?]) -> Bool {
//    <#function body#>
//}
//
//func hasAStraight(cards: [Card?]) -> Bool {
//    <#function body#>
//}
//
//func hasAThreeOfAKind(cards: [Card?]) -> Bool {
//    <#function body#>
//}
//
//func hasATwoPair(cards: [Card?]) -> Bool {
//    <#function body#>
//}
//
//func hasAOnePair(cards: [Card?]) -> Bool {
//    <#function body#>
//}


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
