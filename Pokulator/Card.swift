//
//  Card.swift
//  Pokulator
//
//  Created by Edward Huang on 4/5/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation

struct Card: Hashable {
    /// The value of the Card [1,13]
    var value: Int
    var suit: Suit
    init(value v: Int, suit s: Suit) {
        self.value = v
        self.suit = s
    }
    
    init(value v: Int = 0, suit s: Int = 0) {
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
    /// 1-indexed
    ///
    /// - Parameter index: card index
    init(index: Int) {
        let mod = (index % 13)
        self.value = mod == 0 ? 13 : mod
        if index <= 13 {
            self.suit = .clubs
        } else if index <= 26 {
            self.suit = .diamonds
        } else if index <= 39 {
            self.suit = .hearts
        } else {
            self.suit = .spades
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
    
    static func suitToIndex(suit: Suit) -> Int {
        switch suit {
        case .clubs:
            return 0
        case .diamonds:
            return 1
        case .hearts:
            return 2
        case .spades:
            return 3
        default:
            return 0
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
    
    
    //Conforming to the hash protocol
    var hashValue: Int {
        switch suit {
        case .clubs:
            return value
        case .diamonds:
            return 13 + value
        case .hearts:
            return 26 + value
        case .spades:
            return 39 + value
        default:
            return -1
        }
    }
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.value == rhs.value && lhs.suit == rhs.suit
    }
    
}
