//
//  OpponentsPicker.swift
//  Pokulator
//
//  Created by Edward Huang on 4/7/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation
import UIKit

class OppponentPicker: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    // UIPicker Protocol Stuff...
    // Number of Components
    
    private var num_opp = 1
    
    func get_number_opponents() -> Int {
        return num_opp
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 9
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    // What to do when user selects something
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.num_opp = row + 1
    }
}
