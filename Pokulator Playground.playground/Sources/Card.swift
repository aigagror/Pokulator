//
//  Card.swift
//  Pokulator
//
//  Created by Edward Huang on 4/5/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation

public struct Card {
    /// The value of the Card [1,13]
    var value: Int
    var suit: Suit
    init(value v: Int, suit s: Suit) {
        self.value = v
        self.suit = s
    }
    
    public init(value v: Int, suit s: Int) {
        self.value = v
        
        switch s {
        case 0:
            suit =  Suit.clubs
        case 1:
            suit =  Suit.diamonds
        case 2:
            suit = Suit.hearts
        case 3:
            suit = Suit.spades
        default:
            suit = Suit.clubs
        }
    }
    
    static func indexToSuit(index: Int) -> Suit {
        switch index {
        case 0:
            return Suit.clubs
        case 1:
            return Suit.diamonds
        case 2:
            return Suit.hearts
        case 3:
            return Suit.spades
        default:
            return Suit.clubs
        }
    }
    
    func getFilename() -> String {
        var valueString: String
        switch self.value {
        case 1:
            valueString = "ace"
        case 11:
            valueString = "jack"
        case 12:
            valueString = "queen"
        case 13:
            valueString = "king"
        default:
            valueString = "\(self.value)"
        }
        
        var suitString: String
        switch self.suit {
        case Suit.clubs:
            suitString = "clubs"
        case Suit.diamonds:
            suitString = "diamonds"
        case Suit.hearts:
            suitString = "hearts"
        case Suit.spades:
            suitString = "spades"
        default:
            break
        }
        
        return valueString + "_of_" + suitString
    }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.value == rhs.value && lhs.suit == rhs.suit
    }
    
    
}
