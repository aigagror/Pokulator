//
//  Card.swift
//  Pokulator
//
//  Created by Edward Huang on 4/5/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation

class Card {
    var value: Int
    var suit: Suit
    init(value v: Int, suit s: Suit) {
        self.value = v
        self.suit = s
    }
}
