//
//  CardStatistics.swift
//  Pokulator
//
//  Created by Edward Huang on 4/5/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation

/// Gives a summary of how good the hand is
///
/// - Parameter cards: cards that are known so far
/// - Returns: an array of keys of all possible hands along with their probabilities
func cardStatistics(cards: Set<Card>) -> [GenericHand : Double] {
    var ret = [GenericHand : Double]()

    //check if all the cards are filled
    if cards.count == 7 {
        return ret
    }
    
    let curr_hand = getCurrentKnownHand(cards: cards)
    if curr_hand == GenericHand.straightFlush {
        return ret
    }
    for i in GenericHand.straightFlush.rawValue ... curr_hand.rawValue-1 {
        switch GenericHand(rawValue: i)! {
        case GenericHand.onePair:
            ret[GenericHand(rawValue: i)!] = probOnePair(cards: cards)
        default:
            ret[GenericHand(rawValue: i)!] = 0
        }
    }
    return ret
}
