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
    @IBOutlet var blur_effect: UIVisualEffectView!
    @IBOutlet var add_card_view: UIView!
    @IBOutlet weak var card_picker_view: UIPickerView!
    
    @IBOutlet weak var left_hand: UIButton!
    @IBOutlet weak var right_hand: UIButton!
    @IBOutlet weak var flop1: UIButton!
    @IBOutlet weak var flop2: UIButton!
    @IBOutlet weak var flop3: UIButton!
    @IBOutlet weak var turn: UIButton!
    @IBOutlet weak var river: UIButton!

    var card_button_array = Array<UIButton>()
    
    
    
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
        
        self.card_button_array.append(left_hand)
        self.card_button_array.append(right_hand)
        self.card_button_array.append(flop1)
        self.card_button_array.append(flop2)
        self.card_button_array.append(flop3)
        self.card_button_array.append(turn)
        self.card_button_array.append(river)
        
//        self.effect = self.visual_effect_view.effect
//        self.visual_effect_view.effect = nil
        self.add_card_view.layer.cornerRadius = 5
        
    }
    
    /// Updates the cards on the screen
    ///
    /// - Parameter cards: an array of card optionals
    func updateCards(cards: Array<Card?>) -> Void {
        for i in 0...6 {
            if let card = cards[i] {
                card_button_array[i].setImage(UIImage(named: card.getFilename()), for: UIControlState.normal)
            }
        }
    }
    
    func animate_in() -> Void {
        self.view.addSubview(blur_effect)
        blur_effect.center = self.view.center
        blur_effect.frame = self.view.frame
        self.view.addSubview(add_card_view)
        card_picker_view.selectRow(0, inComponent: 0, animated: true)
        card_picker_view.selectRow(0, inComponent: 1, animated: true)
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
            self.updateCards(cards: self.card_picker.getCards())
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Card Selection Stuff...
    @IBAction func left_hand_tapped(_ sender: Any) {
        if card_picker.setCardIndex(index: 0) {
            animate_in()
        }
    }
    @IBAction func right_hand_tapped(_ sender: Any) {
        if card_picker.setCardIndex(index: 1) {
            animate_in()
        }
    }
    @IBAction func flop1_tapped(_ sender: Any) {
        if card_picker.setCardIndex(index: 2) {
            animate_in()
        }
    }
    @IBAction func flop2_tapped(_ sender: Any) {
        if card_picker.setCardIndex(index: 3) {
            animate_in()
        }
    }
    @IBAction func flop3_tapped(_ sender: Any) {
        if card_picker.setCardIndex(index: 4) {
            animate_in()
        }
    }
    @IBAction func turn_tapped(_ sender: Any) {
        if card_picker.setCardIndex(index: 5) {
            animate_in()
        }
    }
    @IBAction func river_tapped(_ sender: Any) {
        if card_picker.setCardIndex(index: 6) {
            animate_in()
        }
    }


}

