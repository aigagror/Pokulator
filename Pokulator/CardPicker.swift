//
//  CardPicker.swift
//  Pokulator
//
//  Created by Edward Huang on 4/6/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation
import UIKit

class CardPicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    /// Indicates which card we're on. (0 is left hand, 2 is flop1 and 6 is river)
    private var card_index = 0
    
    /// Holds the information for what the cards on the table are
    private var cards = Array<Card?>(repeating: nil, count: 7)
    
    /// Attempts to modify the card. May reject if the index is out of bounds of [0,6], or is at an index where previous cards have not been set yet
    ///
    /// - Parameter index: index for the card
    /// - Returns: returns whether or not the card is set for editing
    func setCardIndex(index: Int) -> Bool {
        if index > 6 || index < 0 {
            return false
        } else {
            if index > 0 {
                for i in 0...index - 1 {
                    if cards[i] == nil {
                        // need to pick previous cards first
                        return false
                    }
                }
            }
            
            // can edit this card
            card_index = index
            
            // set the default card (Ace of clubs) if there is none and if it's available
            if cards[index] == nil {
                let card = Card(value: 1, suit: Suit.clubs)
                if cardIsAvailable(card: card) {
                    cards[index] = card
                }
            }
            return true
        }
    }
    
    
    /// Returns the array of cards
    ///
    /// - Returns: an array of Cards
    func getCards() -> Array<Card?> {
        return cards
    }
    
    /// Resets the cards
    func reset() -> Void {
        card_index = 0
        for i in 0...6 {
            cards[i] = nil
        }
    }
    
    func cardIsAvailable(card: Card) -> Bool {
        for c in cards {
            if let cd = c {
                if cd == card {
                    return false
                }
            }
        }
        return true
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            if cards[card_index] != nil {
                var card = cards[card_index]!
                card.value = row + 1
                if cardIsAvailable(card: card) {
                    cards[card_index] = card
                }
            } else {
                let card = Card(value: row + 1, suit: Suit.clubs)
                if cardIsAvailable(card: card) {
                    cards[card_index] = card
                }
            }
        } else {
            if cards[card_index] != nil {
                var card = cards[card_index]!
                card.suit = Card.indexToSuit(index: row)
                if cardIsAvailable(card: card) {
                    cards[card_index] = card
                }
            } else {
                let card = Card(value: 1, suit: row)
                if cardIsAvailable(card: card) {
                    cards[card_index] = card
                }
            }
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return 13
        } else {
            return 4
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            if row <= 9 && row > 0 {
                return "\(row + 1)"
            } else {
                switch row {
                case 0:
                    return "A"
                case 10:
                    return "J"
                case 11:
                    return "Q"
                case 12:
                    return "K"
                default:
                    return nil
                }
            }
            
        } else {
            return Card.indexToSuit(index: row).rawValue
        }
    }
}
