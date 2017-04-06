//
//  ViewController.swift
//  Pokulator
//
//  Created by Edward Huang on 4/3/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var num_opp: UIPickerView!
    @IBOutlet weak var flop1: UIImageView!
    @IBOutlet weak var flop2: UIImageView!
    @IBOutlet weak var flop3: UIImageView!
    @IBOutlet weak var turn: UIImageView!
    @IBOutlet weak var river: UIImageView!
    @IBOutlet weak var left_hand: UIImageView!
    @IBOutlet weak var right_hand: UIImageView!

    
    
    /// Indicates which card we're on. (0 is left hand, 2 is flop1 and 6 is river)
    var curr_card_index = 0
    
    /// Holds the information for what the cards on the table are
    var cards = Array<Card?>(repeating: nil, count: 6)
    
    
    /// Indicates how many opponents there are. Helps determine statistics
    var num_opponents = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.num_opp.delegate = self
        self.num_opp.dataSource = self
        
        self.num_opponents = num_opp.selectedRow(inComponent: 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // Card selection stuff
    @IBAction func left_hand_tapped(_ sender: Any) {
        if self.curr_card_index >= 0 {
            let c = arc4random_uniform(13) + 1
            left_hand.image = UIImage(named: "card\(c)")
            self.curr_card_index += 1
        }
    }
    @IBAction func right_hand_tapped(_ sender: Any) {
        if self.curr_card_index >= 1 {
            let c = arc4random_uniform(13) + 1
            right_hand.image = UIImage(named: "card\(c)")
            self.curr_card_index += 1
        }
    }
    
    @IBAction func flop1_tapped(_ sender: Any) {
        if self.curr_card_index >= 2 {
            let c = arc4random_uniform(13) + 1
            flop1.image = UIImage(named: "card\(c)")
            self.curr_card_index += 1
        }
    }
    
    
    
    
    // UIPicker Protocol Stuff...
    // Number of Components
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    
    // What to do when user selects something
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.num_opponents = row
    }


}

