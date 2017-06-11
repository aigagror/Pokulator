//
//  CardSelectorViewController.swift
//  Pokulator
//
//  Created by Edward Huang on 6/10/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit
import os.log

class CardSelectorViewController: UIViewController {

    // MARK: Properties
    
    @IBOutlet weak var cardPreview: CardPreview!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var selectedValue: Int? = nil
    var selectedSuit: Suit? = nil
    
    
    
    var currCardIndex = 0
    
    var round = Round.hand
    
    
    var selectedCards = [Card]()
    
    
    // MARK: Private Methods
    
    func trySelectionHelper(potentialCard: Card) -> Void {
        var cardIsValid = true
        
        let givenCards = getCards()
        for card in givenCards {
            if card == potentialCard {
                cardIsValid = false
                print("Duplicate Card")
                break
            }
        }
        for card in selectedCards {
            if card == potentialCard {
                cardIsValid = false
                print("Duplicate Card")
                break
            }
        }
        
        if cardIsValid {
            if currCardIndex == selectedCards.count {
                selectedCards.append(potentialCard)
            } else {
                selectedCards[currCardIndex] = potentialCard
            }
            
            selectedValue = nil
            selectedSuit = nil
            
            currCardIndex += 1
            cardPreview.updateCards(cards: selectedCards, currIndex: currCardIndex)
        }
    }
    
    func trySelection(value: Int? = nil, suit: Suit? = nil) -> Void {
        
        switch round {
        case .hand:
            if currCardIndex == 2 {
                return
            }
        case .flop:
            if currCardIndex == 3 {
                return
            }
        default:
            if currCardIndex == 1 {
                return
            }
        }
        
        if let v = value {
            if let s = selectedSuit {
                // check if this card is valid
                
                let potentialCard = Card(value: v, suit: s)
                trySelectionHelper(potentialCard: potentialCard)
                
            } else {
                selectedValue = v
            }
        }
        
        
        if let s = suit {
            if let v = selectedValue {
                // check if this card is valid
                
                let potentialCard = Card(value: v, suit: s)
                trySelectionHelper(potentialCard: potentialCard)
            } else {
                selectedSuit = s
            }
        }
    }
    
    
    
    // MARK: Button Presses
    
    @IBAction func cancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    // MARK: Value
    @IBAction func two(_ sender: Any) {
        
        trySelection(value: 2, suit: nil)
    }
    
    @IBAction func three(_ sender: Any) {
        trySelection(value: 3, suit: nil)
    }
    
    @IBAction func four(_ sender: Any) {
        trySelection(value: 4, suit: nil)
    }
    
    @IBAction func five(_ sender: Any) {
        trySelection(value: 5, suit: nil)
    }
    
    @IBAction func six(_ sender: Any) {
        trySelection(value: 6, suit: nil)
    }
    
    @IBAction func seven(_ sender: Any) {
        trySelection(value: 7, suit: nil)
    }
    
    @IBAction func eight(_ sender: Any) {
        trySelection(value: 8, suit: nil)
    }
    
    @IBAction func nine(_ sender: Any) {
        trySelection(value: 9, suit: nil)
    }
    
    @IBAction func ten(_ sender: Any) {
        trySelection(value: 10, suit: nil)
    }
    
    @IBAction func jack(_ sender: Any) {
        trySelection(value: 11, suit: nil)
    }
    
    @IBAction func queen(_ sender: Any) {
        trySelection(value: 12, suit: nil)
    }
    
    @IBAction func king(_ sender: Any) {
        trySelection(value: 13, suit: nil)
    }
    
    @IBAction func ace(_ sender: Any) {
        trySelection(value: 1, suit: nil)
    }
    
    //MARK: Suit
    
    @IBAction func club(_ sender: Any) {
        trySelection(value: nil, suit: .clubs)
    }
    
    @IBAction func diamond(_ sender: Any) {
        trySelection(value: nil, suit: .diamonds)
    }
    
    @IBAction func heart(_ sender: Any) {
        trySelection(value: nil, suit: .hearts)
    }
    
    @IBAction func spade(_ sender: Any) {
        trySelection(value: nil, suit: .spades)
    }
    
    
    
    @IBAction func back(_ sender: Any) {
        currCardIndex = currCardIndex == 0 ? 0 : currCardIndex - 1
        cardPreview.updateCards(cards: selectedCards, currIndex: currCardIndex)
    }
    @IBAction func forward(_ sender: Any) {
        if currCardIndex == selectedCards.count {
            return
        }
        currCardIndex = currCardIndex == cardPreview.cardCount ? currCardIndex : currCardIndex + 1
        cardPreview.updateCards(cards: selectedCards, currIndex: currCardIndex)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        selectedCards.removeAll()
        
        switch round {
        case .hand:
            cardPreview.cardCount = 2
        case .flop:
            cardPreview.cardCount = 3
        default:
            cardPreview.cardCount = 1
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else
        { os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        // update the cardss
        
        
    }

}
