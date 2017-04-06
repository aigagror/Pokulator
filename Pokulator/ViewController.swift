//
//  ViewController.swift
//  Pokulator
//
//  Created by Edward Huang on 4/3/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var num_opp_picker: UIPickerView!
    @IBOutlet weak var left_hand: UIButton!
    @IBOutlet var add_card_view: UIView!
    @IBOutlet weak var visual_effect_view: UIVisualEffectView!
    var effect:UIVisualEffect!
    
    var card_view_array = [UIImageView]()

    
    
    /// Indicates which card we're on. (0 is left hand, 2 is flop1 and 6 is river)
    var curr_card_index = 0
    
    /// Holds the information for what the cards on the table are
    var cards = Array<Card?>(repeating: nil, count: 6)
    
    
    /// Indicates how many opponents there are. Helps determine statistics
    var num_opponents = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.num_opp_picker.delegate = self
        self.num_opp_picker.dataSource = self
        
        self.num_opponents = num_opp_picker.selectedRow(inComponent: 0)
        
        self.effect = self.visual_effect_view.effect
        self.visual_effect_view.effect = nil
        self.add_card_view.layer.cornerRadius = 5
        
    }
    
    func animate_in() -> Void {
        self.view.addSubview(add_card_view)
        add_card_view.center = self.view.center
        
        add_card_view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        add_card_view.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visual_effect_view.effect = self.effect
            self.add_card_view.alpha = 1
            self.add_card_view.transform = CGAffineTransform.identity
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Card Selection Stuff...
    @IBAction func left_hand_tapped(_ sender: Any) {
        animate_in()
        left_hand.setImage(UIImage(named: "2_of_clubs"), for: UIControlState.normal)
    }
    @IBAction func right_hand_tapped(_ sender: Any) {
    }
    @IBAction func flop1_tapped(_ sender: Any) {
    }
    @IBAction func flop2_tapped(_ sender: Any) {
    }
    @IBAction func flop3_tapped(_ sender: Any) {
    }
    @IBAction func turn_tapped(_ sender: Any) {
    }
    @IBAction func river_tapped(_ sender: Any) {
    }
    
    
    
    // UIPicker Protocol Stuff...
    // Number of Components
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
        self.num_opponents = row + 1
    }


}

