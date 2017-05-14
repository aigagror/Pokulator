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
    
    private var selected_card = Card(value: 1, suit: .clubs)
    
    /// Attempts to modify the card. May reject if the index is out of bounds of [0,6], or is at an index where previous cards have not been set yet
    ///
    /// - Parameter index: index for the card
    /// - Returns: returns whether or not the card is set for editing
    func setCardIndex(index: Int, with_selection: Card?) -> Bool {
        let cards = getCards()
        if index > 6 || index < 0 {
            return false
        }
        if cards.count < index {
            return false
        }
        
        // can edit this card
        card_index = index
        
        // set the default selection
        if let selection = with_selection {
            selected_card = selection
        } else {
            selected_card = Card(value: 1, suit: .clubs)
        }
        
        return true
    }
    
    /// Call this function when you're done with your selection so it'll finalize your card pick
    func aboutToAnimateOut() -> Void {
        if cardIsAvailable(card: selected_card) {
            var cards = getCards()
            if cards.count == card_index {
                cards.append(selected_card)
            } else {
                assert(cards.count > card_index)
                cards[card_index] = selected_card
            }
            update(new_cards: cards)
        }
    }
    
    ///
    ///
    /// - Parameter index: index in question
    /// - Returns: card at that index. nil if there is none
    func cardAt(index: Int) -> Card? {
        let cards = getCards()
        if cards.count > index {
            return cards[index]
        } else {
            return nil
        }
    }
    
    /// Resets the cards
    func reset() -> Void {
        card_index = 0
        update(new_cards: Array<Card>())
    }
    
    func cardIsAvailable(card: Card) -> Bool {
        let cards = getCards()
        for c in cards {
            if c == card {
                return false
            }
        }
        return true
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            selected_card.value = row + 1
        } else {
            selected_card.suit = Card.indexToSuit(index: row)
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50
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
