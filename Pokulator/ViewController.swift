//
//  ViewController.swift
//  Pokulator
//
//  Created by Edward Huang on 4/3/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController, StatsDelegate {

    
    @IBOutlet var stats: [UILabel]!
    
    @IBOutlet weak var hand_label: UILabel!
    @IBOutlet weak var opponent_label: UILabel!
    
    @IBOutlet var card_views: [UIView]!
        
    
    var card_view_array = [UIImageView]()
    
    
    
    

    @IBAction func reset(_ sender: Any) {
        
        
        update(new_cards: Array<Card>())
        
        
        updateScreen()
    }
    
    @IBAction func changed_opponent_count(_ sender: UIStepper) {
        
        let n = Int(sender.value)
        
        opponent_label.text = "\(n)"
        
        update(new_cards: nil, new_opponents: n)
        
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        statsDelegate = self
        
        startCalculating()
        
        updateScreen()
    }
    
    
    func updateStats(handData: [GenericHand:Double], win: Double) -> Void {
        
        for stat in stats {
            let handText = stat.accessibilityIdentifier ?? ""
            
            var value = 0.0
            
            switch handText {
            case "highCard":
                value = handData[.highCard]!
            case "onePair":
                 value = handData[.onePair]!
            case "twoPair":
                value = handData[.twoPair]!
            case "threeOfAKind":
                value = handData[.threeOfAKind]!
            case "straight":
                value = handData[.straight]!
            case "flush":
                value = handData[.flush]!
            case "fullHouse":
                value = handData[.fullHouse]!
            case "fourOfAKind":
                value = handData[.fourOfAKind]!
            case "straightFlush":
                value = handData[.straightFlush]!
            case "win":
                value = win
            default:
                fatalError("should not be here")
            }
            
            
            
            
            if value == 0.0 {
                stat.text = "-"
            } else {
                stat.text = "\((value * 100).rounded() / 100.0)"
            }
        }
    }
    
    
    
    
    /// Updates the cards on the screen
    func updateScreen() -> Void {
        let cards = getCards()
        for i in 0...6 {
            
            var viewName = ""
            switch i {
            case 0:
                viewName = "leftHand"
            case 1:
                viewName = "rightHand"
            case 2:
                viewName = "flop1"
            case 3:
                viewName = "flop2"
            case 4:
                viewName = "flop3"
            case 5:
                viewName = "turn"
            case 6:
                viewName = "river"
            default:
                fatalError("Should not be here")
            }
            
            var cardView = UIView();
            for view in card_views {
                if view.restorationIdentifier ?? "" == viewName {
                    cardView = view
                }
            }
            
            
            if i < cards.count {
                let card = cards[i]
                
                guard let cardImage = UIImage(named: card.getFilename()) else {
                    fatalError("Could not get card image")
                }
                
                let cardImageView = UIImageView(image: cardImage)
                cardImageView.frame = cardView.frame
                let origin = CGPoint(x: cardView.frame.width / 2, y: cardView.frame.height / 2)
                cardImageView.center = origin
        
                
                cardView.addSubview(cardImageView)
            } else {
                
                let subviews = cardView.subviews
                
                for subview in subviews {
                    subview.removeFromSuperview()
                }
            }
        }
        
        let curr_hand = getCurrentKnownHand(cards: cards)
        hand_label.text = toString(hand: getGeneric(curr_hand))
    }
    
    
    
    // Card Selection Stuff...
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // all destinations lead to card selector view controller
        
        if let cardSelectorViewController = segue.destination as? CardSelectorViewController {
            let currentRound = getRound()
            cardSelectorViewController.round = currentRound
            
            
            switch (segue.identifier ?? "") {
            case "hand":
                os_log("Selecting for hand...", log: OSLog.default, type: .debug)
                
                cardSelectorViewController.round = .hand
                cardSelectorViewController.selectedCards = getCards(fromRound: .hand)
                
            case "flop":
                os_log("Selecting for flop...", log: OSLog.default, type: .debug)
                
                if currentRound != .hand {
                    cardSelectorViewController.round = .flop
                    cardSelectorViewController.selectedCards = getCards(fromRound: .flop)
                }
                
                
            case "turn":
                os_log("Selecting for turn...", log: OSLog.default, type: .debug)
                
                if currentRound == .turn || currentRound == .river {
                    cardSelectorViewController.round = .turn
                    cardSelectorViewController.selectedCards = getCards(fromRound: .turn)
                }
                
                
                
            case "river":
                os_log("Selecting for river...", log: OSLog.default, type: .debug)
                
                if currentRound == .river {
                    cardSelectorViewController.round = .river
                    cardSelectorViewController.selectedCards = getCards(fromRound: .river)
                    
                }
                
            default:
                fatalError("Unexpected Segue Identifier; \(segue.identifier ?? "")")
            }
        } 
        
    }
    
    
    // MARK: Actions
    
    @IBAction func unwindToMainMenu(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CardSelectorViewController {
            
            let selectedCards = sourceViewController.selectedCards
            
            let round = sourceViewController.round
            
            
            var givenCards = getCards()
            
            
            switch round {
            case .hand:
                if givenCards.count == 0 {
                    givenCards.append(contentsOf: selectedCards)
                } else {
                    for i in 0...1 {
                        givenCards[i] = selectedCards[i]
                    }
                }
            case .flop:
                if givenCards.count <= 2 {
                    givenCards.append(contentsOf: selectedCards)
                } else {
                    for i in 0...2 {
                        givenCards[i+2] = selectedCards[i]
                    }
                }
                
            case .turn:
                if givenCards.count < 6 {
                    givenCards.append(contentsOf: selectedCards)
                } else {
                    givenCards[5] = selectedCards.first!
                }
            case .river:
                if givenCards.count < 7 {
                    givenCards.append(contentsOf: selectedCards)
                } else {
                    givenCards[6] = selectedCards.first!
                }
            }
            
            update(new_cards: givenCards, new_opponents: nil)
            
            updateScreen()
        }
    }
    
    
    
    
    
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

