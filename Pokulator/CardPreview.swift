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
    
    var highlighted = 0 {
        didSet{
            updateCardViewStates()
        }
    }
    
    @IBInspectable var cardSize: CGSize = CGSize(width: 50.0, height: 72.6) {
        didSet {
            setupCards()
        }
    }
    
    @IBInspectable var cardCount: Int = 3 {
        didSet {
            setupCards()
        }
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
        
        
        
    }
    
    
    private func updateCardViewStates() -> Void {
        
    }

}
