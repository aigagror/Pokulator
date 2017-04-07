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
    private var cards = Array<Card?>(repeating: nil, count: 6)
    
    func getCards() -> Array<Card?> {
        return cards
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            if var card = cards[card_index] {
                card.value = row
            } else {
                cards[card_index] = Card(row, suit: 0)
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
                    return "Ace"
                case 10:
                    return "Jack"
                case 11:
                    return "Queen"
                case 12:
                    return "King"
                default:
                    return nil
                }
            }
            
        } else {
            return String(describing: Card.getSuit(index: row))
        }
    }
}
