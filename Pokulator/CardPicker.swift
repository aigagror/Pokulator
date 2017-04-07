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
            switch row {
            case 0:
                return "\(Suit.clubs.rawValue)"
            case 1:
                return "\(Suit.diamonds.rawValue)"
            case 2:
                return "\(Suit.hearts.rawValue)"
            case 3:
                return "\(Suit.spades.rawValue)"
            default:
                return nil
            }
        }
    }
}
