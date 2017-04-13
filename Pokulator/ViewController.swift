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
    
    @IBOutlet weak var hand_label: UILabel!
    

    private var card_button_array = Array<UIButton>()
    
    
    
    let card_picker = CardPicker()
    let opponent_picker = OppponentPicker()
    
    var card_view_array = [UIImageView]()

    @IBAction func pop_out(_ sender: Any) {
        animate_out()
    }
    @IBAction func reset(_ sender: Any) {
        card_picker.reset()
        updateCards()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Setting up the picker views
        self.num_opp_picker.delegate = self.opponent_picker
        self.num_opp_picker.dataSource = self.opponent_picker
        
        self.card_picker_view.delegate = self.card_picker
        self.card_picker_view.dataSource = self.card_picker
        
        // Setting up card buttons
        self.card_button_array.append(left_hand)
        self.card_button_array.append(right_hand)
        self.card_button_array.append(flop1)
        self.card_button_array.append(flop2)
        self.card_button_array.append(flop3)
        self.card_button_array.append(turn)
        self.card_button_array.append(river)
        
        // A little aesthetic stuff to the add card view
        self.add_card_view.layer.cornerRadius = 5
        
    }
    
    /// Updates the cards on the screen
    ///
    /// - Parameter cards: an array of card optionals
    func updateCards() -> Void {
        let cards = card_picker.getCards()
        for i in 0...6 {
            if let card = cards[i] {
                card_button_array[i].setImage(UIImage(named: card.getFilename()), for: UIControlState.normal)
            } else {
                card_button_array[i].setImage(nil, for: UIControlState.normal)
            }
        }
        
        let curr_hand = getCurrentKnownHand(cards: cards)
        switch curr_hand {
        case .straightFlush:
            hand_label.text = "Straight Flush"
        case .fourOfAKind:
            hand_label.text = "Four of a Kind"
        case .fullHouse:
            hand_label.text = "Full House"
        case .flush:
            hand_label.text = "Flush"
        case .straight:
            hand_label.text = "Straight"
        case .threeOfAKind:
            hand_label.text = "Three of a Kind"
        case .twoPair:
            hand_label.text = "Two Pair"
        case .onePair:
            hand_label.text = "One Pair"
        case .highCard:
            hand_label.text = "High Card"
        default:
            break
        }
        
    }
    
    /// Animates in the card picker view
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
            self.updateCards()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Card Selection Stuff...
    
    func tryPickingAt(index: Int) -> Void {
        if card_picker.setCardIndex(index: index) {
            if let card = card_picker.cardAt(index: index) {
                let suit_index = Card.suitToIndex(suit: card.suit)
                card_picker_view.selectRow(card.value - 1, inComponent: 0, animated: true)
                card_picker_view.selectRow(suit_index, inComponent: 1, animated: true)
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


}

