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
    
    @IBOutlet var stats: [UILabel]!
    
    @IBOutlet weak var hand_label: UILabel!
    
    @IBOutlet var card_buttons: [UIButton]!
    
    
    let card_picker = CardPicker()
    let opponent_picker = OppponentPicker()
    
    var card_view_array = [UIImageView]()

    @IBAction func pop_out(_ sender: Any) {
        animate_out()
    }
    @IBAction func reset(_ sender: Any) {
        card_picker.reset()
        updateScreen()
    }
    
    //background calculations
    let calculatorQueue = DispatchQueue(label: "calculator_queue", qos: .background)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setting up the picker views
        self.num_opp_picker.delegate = self.opponent_picker
        self.num_opp_picker.dataSource = self.opponent_picker
        
        self.card_picker_view.delegate = self.card_picker
        self.card_picker_view.dataSource = self.card_picker
        
        
        // A little aesthetic stuff to the add card view
        self.add_card_view.layer.cornerRadius = 20
        self.card_picker_view.layer.cornerRadius = 20
        
        
        // Start up the calculations
        calculatorQueue.async {
            while true {
                monteCarlo(n: 10_000)
                
                var new_data = [GenericHand:Double]()
                
                let hand_data = getHandData()
                let hand_trials = getHandTrials()
                let wins = getWins()
                let win_trials = getWinTrials()
                let winPercentage = Double(wins*100) / Double(win_trials)
                
                for (hand,n) in hand_data {
                    new_data[hand] = Double(n*100) / Double(hand_trials)
                }
                
                DispatchQueue.main.sync {
                    updateStats(stats: self.stats, handData: new_data, win: winPercentage)
                    print("HT: \(hand_trials), WT: \(win_trials), Wins: \(wins)")
                }
            }
        }
        
        updateScreen()
    }
    
    /// Updates the cards on the screen
    func updateScreen() -> Void {
        let cards = getCards()
        for i in 0...6 {
            if i < cards.count {
            card_buttons[i].setImage(UIImage(named: cards[i].getFilename()), for: UIControlState.normal)
            } else {
                card_buttons[i].setImage(nil, for: UIControlState.normal)
            }
        }
        
        let curr_hand = getCurrentKnownHand(cards: cards)
        hand_label.text = toString(hand: getGeneric(curr_hand))
    }
    
    /// Animates in the card picker view
    func animate_in() -> Void {
        self.view.addSubview(blur_effect)
        blur_effect.center = self.view.center
        blur_effect.frame = self.view.frame
        self.view.addSubview(add_card_view)
        add_card_view.center = self.view.center
        add_card_view.center.y += 130
        
        add_card_view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        add_card_view.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.add_card_view.alpha = 1
            self.add_card_view.transform = CGAffineTransform.identity
        }
    }
    
    /// Animates out the card picker view
    func animate_out() -> Void {
        card_picker.aboutToAnimateOut()
        UIView.animate(withDuration: 0.3, animations: {
            self.add_card_view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.add_card_view.alpha = 0
        }, completion: {(success: Bool) in
            self.add_card_view.removeFromSuperview()
            self.blur_effect.removeFromSuperview()
            self.updateScreen()
        })
    }
    
    // Card Selection Stuff...
    
    func tryPickingAt(index: Int) -> Void {
        let cards = getCards()
        var card:Card? = nil
        if index < cards.count {
            card = cards[index]
        }
        if card_picker.setCardIndex(index: index, with_selection: card) {
            if let card = card_picker.cardAt(index: index) {
                let suit_index = Card.suitToIndex(suit: card.suit)
                card_picker_view.selectRow(card.value - 1, inComponent: 0, animated: true)
                card_picker_view.selectRow(suit_index, inComponent: 1, animated: true)
            } else {
                card_picker_view.selectRow(0, inComponent: 0, animated: true)
                card_picker_view.selectRow(0, inComponent: 1, animated: true)
            }
            animate_in()
        }
    }
    
    @IBAction func left_hand_tapped(_ sender: Any) {
        tryPickingAt(index: 0)
    }
    @IBAction func right_hand_tapped(_ sender: Any) {
        tryPickingAt(index: 1)
    }
    @IBAction func flop1_tapped(_ sender: Any) {
        tryPickingAt(index: 2)
    }
    @IBAction func flop2_tapped(_ sender: Any) {
        tryPickingAt(index: 3)
    }
    @IBAction func flop3_tapped(_ sender: Any) {
        tryPickingAt(index: 4)
    }
    @IBAction func turn_tapped(_ sender: Any) {
        tryPickingAt(index: 5)
    }
    @IBAction func river_tapped(_ sender: Any) {
        tryPickingAt(index: 6)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

