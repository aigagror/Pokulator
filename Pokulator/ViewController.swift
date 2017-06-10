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
    
    @IBOutlet var stats: [UILabel]!
    
    @IBOutlet weak var hand_label: UILabel!
    
    @IBOutlet var card_views: [UIView]!
    
    
    let opponent_picker = OppponentPicker()
    
    var card_view_array = [UIImageView]()
    
    
    //background calculations
    let calculatorQueue = DispatchQueue(label: "calculator_queue", qos: .background)
    

    @IBAction func reset(_ sender: Any) {
        
        
        update(new_cards: Array<Card>())
        
        
        updateScreen()
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setting up the picker views
        self.num_opp_picker.delegate = self.opponent_picker
        self.num_opp_picker.dataSource = self.opponent_picker
        
        
        
        // Start up the calculations
        calculatorQueue.async {
            while true {
                monteCarlo(n: 2_000)
                
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
                // TODO: Add card image
            } else {
                // TODO: Remove card image
            }
        }
        
        let curr_hand = getCurrentKnownHand(cards: cards)
        hand_label.text = toString(hand: getGeneric(curr_hand))
    }
    
    
    
    // Card Selection Stuff...
    
//    func tryPickingAt(index: Int) -> Void {
//        let cards = getCards()
//        var card:Card? = nil
//        if index < cards.count {
//            card = cards[index]
//        }
//        if card_picker.setCardIndex(index: index, with_selection: card) {
//            if let card = card_picker.cardAt(index: index) {
//                let suit_index = Card.suitToIndex(suit: card.suit)
//                card_picker_view.selectRow(card.value - 1, inComponent: 0, animated: true)
//                card_picker_view.selectRow(suit_index, inComponent: 1, animated: true)
//            } else {
//                card_picker_view.selectRow(0, inComponent: 0, animated: true)
//                card_picker_view.selectRow(0, inComponent: 1, animated: true)
//            }
//            animate_in()
//        }
//    }
//    
//    @IBAction func left_hand_tapped(_ sender: Any) {
//        tryPickingAt(index: 0)
//    }
//    @IBAction func right_hand_tapped(_ sender: Any) {
//        tryPickingAt(index: 1)
//    }
//    @IBAction func flop1_tapped(_ sender: Any) {
//        tryPickingAt(index: 2)
//    }
//    @IBAction func flop2_tapped(_ sender: Any) {
//        tryPickingAt(index: 3)
//    }
//    @IBAction func flop3_tapped(_ sender: Any) {
//        tryPickingAt(index: 4)
//    }
//    @IBAction func turn_tapped(_ sender: Any) {
//        tryPickingAt(index: 5)
//    }
//    @IBAction func river_tapped(_ sender: Any) {
//        tryPickingAt(index: 6)
//    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

