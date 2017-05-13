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
    
    // do a values count
    var valuesCount = [Int:Int]()
    for rank in givenRanks {
        valuesCount[rank] = 0
    }
    for card in parsedCards {
        valuesCount[card.value]! += 1
    }
    
    //determine if there's a four of a kind
    if m - givenRanks.count >= 3 {
        for (_,y) in valuesCount {
            if y >= 4 {
                return .fourOfAKind
            }
        }
    }
    
    //determine if there's a full house
    if m - givenRanks.count >= 3 {
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
    if m - givenRanks.count >= 2 {
        for (_,y) in valuesCount {
            if y >= 3 {
                return .threeOfAKind
            }
        }
    }
    
    //determine if there's a two pair
    if m - givenRanks.count >= 2 {
        return .twoPair
    }
    
    //determine if there's a pair
    if m - givenRanks.count >= 1 {
        return .onePair
    } else {
        return .highCard
    }
}

/// Gives the best hand that the opponents have
///
/// - Parameter cards: all of the cards. The first seven are the user's hands and the community cards, the rest are the opponents cardss
/// - Returns: the best hand from all of the opponents
func bestOpponentHand(cards: Array<Card>) -> GenericHand {
    guard cards.count % 2 == 1 && cards.count > 7 else {
        fatalError("given an odd number of opponent cards or not given all necessary cards")
    }
    
    var communityGivenRanks = Set<Int>()
    var communitySuitCount = [Suit.clubs:0, Suit.diamonds:0, Suit.hearts:0, Suit.spades:0]
    for card in cards[2...6] {
        communityGivenRanks.insert(card.value)
        communitySuitCount[card.suit]! += 1
    }
    
    var bestHand = GenericHand.highCard
    let n = cards.count - 7
    for i in 0...(n/2 - 1) {
        var givenRanks = communityGivenRanks
        var suitCount = communitySuitCount
        let o1 = cards[7 + 2*i]
        let o2 = cards[8 + 2*i]
        givenRanks.insert(o1.value)
        givenRanks.insert(o2.value)
        suitCount[o1.suit]! += 1
        suitCount[o2.suit]! += 1
        
        
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
        
        //determine if there's a straight flush. this is the best hand so just return it
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
            for card in cards[2...6] {
                if card.suit == suit {
                    values.insert(card.value)
                }
            }
            if o1.suit == suit {
                values.insert(o1.value)
            }
            if o2.suit == suit {
                values.insert(o2.value)
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
        
        // Do a values count
        var valuesCount = [Int:Int]()
        for rank in givenRanks {
            valuesCount[rank] = 0
        }
        
        for card in cards[2...6] {
            valuesCount[card.value]! += 1
        }
        valuesCount[o1.value]! += 1
        valuesCount[o2.value]! += 1
        
        
        //determine if there's a four of a kind
        if 7 - givenRanks.count >= 3 && bestHand.rawValue >= 2 {
            for (_,y) in valuesCount {
                if y >= 4 {
                    bestHand = .fourOfAKind
                }
            }
        }
        
        //determine if there's a full house
        if 7 - givenRanks.count >= 3 && bestHand.rawValue >= 3 {
            var three = false
            var two = false
            
            for (_,y) in valuesCount {
                if y >= 3 {
                    if three {
                        bestHand = .fullHouse
                        break
                    } else {
                        three = true
                    }
                } else if y >= 2 {
                    two = true
                }
            }
            if two && three {
                bestHand = .fullHouse
            }
        }
        
        //determine if there's a flush
        if flush && bestHand.rawValue >= 4 {
            bestHand = .flush
        }
        
        //determine if there's a straight
        if straight && bestHand.rawValue >= 5 {
            bestHand = .straight
        }
        
        //determine if there's a three of a kind
        if 7 - givenRanks.count >= 2 && bestHand.rawValue >= 6 {
            for (_,y) in valuesCount {
                if y >= 3 {
                    bestHand = .threeOfAKind
                    break
                }
            }
        }
        
        //determine if there's a two pair
        if 7 - givenRanks.count >= 2 && bestHand.rawValue >= 7 {
            bestHand = .twoPair
        }
        
        //determine if there's a pair
        if 7 - givenRanks.count >= 1 && bestHand.rawValue >= 8 {
            bestHand = .onePair
        }
        
        //otherwise do nothing
        
        //try again
    }
    return bestHand
}
