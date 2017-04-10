//
//  Hands.swift
//  Pokulator
//
//  Created by Edward Huang on 4/9/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation

enum Hand {
    
    //Includes the royal flush
    case straightFlush(Card)
    
    case fourtOfAKind(Card)
    
    //Highest 3 matching cards win
    case fullHouse(Card)
    
    //The player holding the highest ranked card wins. If necessary, the second-highest, third-highest, fourth-highest, and fifth-highest cards can be used to break the tie. If all five cards are the same ranks, the pot is split.
    case flush(Card,Card,Card,Card,Card)
    
    case straight(Card)
    
    case threeOfAKind(Card)
    
    //Highest pair wins. If players have the same highest pair, highest second pair wins. If both players have two identical pairs, highest side card wins.
    case twoPair(Card, Card, Card)
    
    //Highest pair wins. If players have the same pair, the highest side card wins, and if necessary, the second-highest and third-highest side card can be used to break the tie.
    case onePair(Card, Card, Card, Card)
    
    case highCard(Card,Card,Card,Card,Card)
    
}
