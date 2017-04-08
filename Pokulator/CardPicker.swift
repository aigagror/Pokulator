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
            
            // set the default card (Ace of clubs) if there is none
            if cards[index] == nil {
                cards[index] = Card(value: 1, suit: Suit.clubs)
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            if cards[card_index] != nil {
                cards[card_index]!.value = row + 1
            } else {
                cards[card_index] = Card(value: row + 1, suit: Suit.clubs)
            }
        } else {
            if cards[card_index] != nil {
                cards[card_index]!.suit = Card.indexToSuit(index: row)
            } else {
                cards[card_index] = Card(value: 1, suit: row)
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
