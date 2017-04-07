//
//  ViewController.swift
//  Pokulator
//
//  Created by Edward Huang on 4/3/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var num_opp_picker: UIPickerView!
    @IBOutlet weak var left_hand: UIButton!
    @IBOutlet var blur_effect: UIVisualEffectView!
    @IBOutlet var add_card_view: UIView!
    @IBOutlet weak var card_picker_view: UIPickerView!
    let card_picker = CardPicker()
    let opponent_picker = OppponentPicker()
    
//    @IBOutlet weak var visual_effect_view: UIVisualEffectView!
//    var effect:UIVisualEffect!
//    
    var card_view_array = [UIImageView]()

    @IBAction func pop_out(_ sender: Any) {
        animate_out()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.num_opp_picker.delegate = self.opponent_picker
        self.num_opp_picker.dataSource = self.opponent_picker
        
        self.card_picker_view.delegate = self.card_picker
        self.card_picker_view.dataSource = self.card_picker
        
//        self.effect = self.visual_effect_view.effect
//        self.visual_effect_view.effect = nil
        self.add_card_view.layer.cornerRadius = 5
        
    }
    
    func animate_in() -> Void {
        self.view.addSubview(blur_effect)
        blur_effect.center = self.view.center
        blur_effect.frame = self.view.frame
        self.view.addSubview(add_card_view)
        add_card_view.center = self.view.center
        add_card_view.center.y += 50
        
        add_card_view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        add_card_view.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
//            self.visual_effect_view.effect = self.effect
            self.add_card_view.alpha = 1
            self.add_card_view.transform = CGAffineTransform.identity
        }
    }
    
    func animate_out() -> Void {
        UIView.animate(withDuration: 0.3, animations: {
            self.add_card_view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.add_card_view.alpha = 0
        }, completion: {(success: Bool) in
            self.add_card_view.removeFromSuperview()
            self.blur_effect.removeFromSuperview()
        })
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


}

