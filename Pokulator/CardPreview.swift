//
//  CardPreview.swift
//  Pokulator
//
//  Created by Edward Huang on 6/10/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import UIKit

@IBDesignable class CardPreview: UIStackView {

    
    // MARK: Properties
    
    private var previewCards = [UIView]()
    private var selectedCards = [Card]()
    private var cardIndex = 0
    
    var highlighted = 0 {
        didSet{
            updateCardViewStates()
        }
    }
    
    @IBInspectable var cardSize: CGSize = CGSize(width: 100, height: 145.2) {
        didSet {
            setupCards()
        }
    }
    
    @IBInspectable var cardCount: Int = 3 {
        didSet {
            setupCards()
        }
    }
    
    @IBInspectable var cardBackgroundColor: UIColor = .lightGray {
        didSet {
            setupCards()
        }
    }
    
    @IBInspectable var cardHighlightColor: UIColor = .gray {
        didSet {
            setupCards()
        }
    }
    
    
    func updateCards(cards: [Card], currIndex: Int) -> Void {
        selectedCards = cards
        cardIndex = currIndex
        
        updateCardViewStates()
    }
    
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCards()
        
        
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        setupCards()
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: Private methods
    
    private func setupCards() {
        
        // clear any existing butons
        for card in previewCards {
            removeArrangedSubview(card)
            card.removeFromSuperview()
        }
        previewCards.removeAll()
        let remainingSentinelViews = self.subviews
        for view in remainingSentinelViews {
            removeArrangedSubview(view)
        }
        
        let sentinelView = UIView()
        sentinelView.translatesAutoresizingMaskIntoConstraints = false
        sentinelView.heightAnchor.constraint(equalToConstant: cardSize.height).isActive = true
        sentinelView.widthAnchor.constraint(equalToConstant: CGFloat(0)).isActive = true
        addArrangedSubview(sentinelView)
        
        for index in 0..<cardCount {
            // Create the card view
            let card = UIView()
            card.backgroundColor = .white
            
            // Add constraints
            
            card.translatesAutoresizingMaskIntoConstraints = false
            card.heightAnchor.constraint(equalToConstant: cardSize.height).isActive = true
            card.widthAnchor.constraint(equalToConstant: cardSize.width).isActive = true
            
            // Set the accessibility label
            card.accessibilityLabel = "Set \(index+1) card preview"
            
            
            // Add the button to the stack
            addArrangedSubview(card)
            
            // Add the new button to the rating button array
            previewCards.append(card)
        }
        
        let sentinelView2 = UIView()
        sentinelView2.translatesAutoresizingMaskIntoConstraints = false
        sentinelView2.heightAnchor.constraint(equalToConstant: cardSize.height).isActive = true
        sentinelView2.widthAnchor.constraint(equalToConstant: CGFloat(0)).isActive = true
        addArrangedSubview(sentinelView2)
        
        updateCardViewStates()
        
    }
    
    private func updateCardViewStates() -> Void {
        
        for i in 0..<cardCount {
            if i < selectedCards.count {
                let card = selectedCards[i]
                
                let cardImage = UIImage(named: card.getFilename())!
                
                let cardImageView = UIImageView(image: cardImage)
                
                let cardSize = CGSize(width: previewCards[i].frame.width * 0.9, height: previewCards[i].frame.height * 0.9)
                let cardOrigin = CGPoint(x: previewCards[i].frame.width / 2, y: previewCards[i].frame.height / 2)
                cardImageView.frame = CGRect(origin: .zero, size: cardSize)
                cardImageView.center = cardOrigin
                
                
                previewCards[i].addSubview(cardImageView)
            } else {
                let subviews = previewCards[i].subviews
                
                for subview in subviews {
                    subview.removeFromSuperview()
                }
            }
            
            if i == cardIndex {
                previewCards[i].backgroundColor = cardHighlightColor
                let subviews = previewCards[i].subviews
                for subview in subviews {
                    if let imageView = subview as? UIImageView {
                        imageView.isHighlighted = true
                    }
                }
            } else {
                previewCards[i].backgroundColor = cardBackgroundColor
                let subviews = previewCards[i].subviews
                for subview in subviews {
                    if let imageView = subview as? UIImageView {
                        imageView.isHighlighted = false
                    }
                }
            }
            
        }
        
    }

}
