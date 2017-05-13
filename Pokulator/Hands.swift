//
//  Hands.swift
//  Pokulator
//
//  Created by Edward Huang on 4/9/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation

enum Hand: Hashable {
    
    //Includes the royal flush
    case straightFlush(Int)
    
    case fourOfAKind(Int)
    
    //Highest 3 matching cards win
    case fullHouse(Int)
    
    //The player holding the highest ranked card wins. If necessary, the second-highest, third-highest, fourth-highest, and fifth-highest cards can be used to break the tie. If all five cards are the same ranks, the pot is split.
    case flush(Int,Int,Int,Int,Int)
    
    case straight(Int)
    
    case threeOfAKind(Int)
    
    //Highest pair wins. If players have the same highest pair, highest second pair wins. If both players have two identical pairs, highest side card wins.
    case twoPair(Int, Int, Int)
    
    //Highest pair wins. If players have the same pair, the highest side card wins, and if necessary, the second-highest and third-highest side card can be used to break the tie.
    case onePair(Int, Int, Int, Int)
    
    case highCard(Int,Int,Int,Int,Int)
    
    // Conforming to the hash protocol
    var hashValue: Int {
        //Hands prime numbers: 53, 59, 61, 67, 71, 73, 79, 83, 89
        
        //Card value prime numbers: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41
        
        let cvp = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41]
        
        
        switch self {
        case .highCard(let c1, let c2, let c3, let c4, let c5):
            return 53 * cvp[c1-1] * cvp[c2-1] * cvp[c3-1] * cvp[c4-1] * cvp[c5-1]
        case .onePair(let c1, let c2, let c3, let c4):
            return 59 * cvp[c1-1] * cvp[c2-1] * cvp[c3-1] * cvp[c4-1]
        case .twoPair(let c1, let c2, let c3):
            return 61 * cvp[c1-1] * cvp[c2-1] * cvp[c3-1]
        case .threeOfAKind(let c1):
            return 67 * cvp[c1-1]
        case .straight(let c1):
            return 71 * cvp[c1-1]
        case .flush(let c1, let c2, let c3, let c4, let c5):
            return 73 * cvp[c1-1] * cvp[c2-1] * cvp[c3-1] * cvp[c4-1] * cvp[c5-1]
        case .fullHouse(let c1):
            return 79 * cvp[c1-1]
        case .fourOfAKind(let c1):
            return 83 * cvp[c1-1]
        case .straightFlush(let c1):
            return 89 * cvp[c1-1]
        default:
            return 0
            print("Error in Hand hash value")
        }
    }
    static func ==(lhs: Hand, rhs: Hand) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    static func <=(lhs: Hand, rhs: Hand) -> Bool {
        let g1 = getGeneric(lhs)
        let g2 = getGeneric(rhs)
        if g2.rawValue < g1.rawValue {
            return true
        } else if g2.rawValue > g1.rawValue {
            return false
        } else {
            // raw values are equal, compare cards
            switch lhs {
            case .highCard(let c):
                switch rhs {
                case .highCard(let d):
                    if c.0 != d.0 {
                        return c.0 < d.0
                    } else if c.1 != d.1 {
                        return c.1 < d.1
                    } else if c.2 != d.2 {
                        return c.2 < d.2
                    } else if c.3 != d.3 {
                        return c.3 < d.3
                    } else if c.4 != d.4 {
                        return c.4 < d.4
                    } else {
                        //tie
                        return true
                    }
                default:
                    fatalError("hands should be equal")
                }
            case .onePair(let c):
                switch rhs {
                case .onePair(let d):
                    if c.0 != d.0 {
                        return c.0 < d.0
                    } else if c.1 != d.1 {
                        return c.1 < d.1
                    } else if c.2 != d.2 {
                        return c.2 < d.2
                    } else if c.3 != d.3 {
                        return c.3 < d.3
                    } else {
                        //tie
                        return true
                    }
                default:
                    fatalError("hands should be equal")
                }
            case .twoPair(let c):
                switch rhs {
                case .twoPair(let d):
                    if c.0 != d.0 {
                        return c.0 < d.0
                    } else if c.1 != d.1 {
                        return c.1 < d.1
                    } else if c.2 != d.2 {
                        return c.2 < d.2
                    } else {
                        //tie
                        return true
                    }
                default:
                    fatalError("hands should be equal")
                }
            case .threeOfAKind(let c):
                switch rhs {
                case .threeOfAKind(let d):
                    if c != d {
                        return c < d
                    } else {
                        //tie
                        return true
                    }
                default:
                    fatalError("hands should be equal")
                }
            case .straight(let c):
                switch rhs {
                case .straight(let d):
                    if c != d {
                        return c < d
                    } else {
                        //tie
                        return true
                    }
                default:
                    fatalError("hands should be equal")
                }
            case .flush(let c):
                switch rhs {
                case .flush(let d):
                    if c.0 != d.0 {
                        return c.0 < d.0
                    } else if c.1 != d.1 {
                        return c.1 < d.1
                    } else if c.2 != d.2 {
                        return c.2 < d.2
                    } else if c.3 != d.3 {
                        return c.3 < d.3
                    } else if c.4 != d.4 {
                        return c.4 < d.4
                    } else {
                        //tie
                        return true
                    }
                default:
                    fatalError("hands should be equal")
                }
            case .fullHouse(let c):
                switch rhs {
                case .fullHouse(let d):
                    if c != d {
                        return c < d
                    } else {
                        //tie
                        return true
                    }
                default:
                    return false
                }
            case .fourOfAKind(let c):
                switch rhs {
                case .fourOfAKind(let d):
                    if c != d {
                        return c < d
                    } else {
                        //tie
                        return true
                    }
                default:
                    fatalError("hands should be equal")
                }
            case .straightFlush(let c):
                switch rhs {
                case .straightFlush(let d):
                    if c != d {
                        return c < d
                    } else {
                        //tie
                        return true
                    }
                default:
                    fatalError("hands should be equal")
                }
            default:
                fatalError("should not be here")
                return false
            }
        }
    }
    
    static func <(lhs: Hand, rhs: Hand) -> Bool {
        if !(lhs <= rhs) {
            return false
        }
        
        switch lhs {
        case .highCard(let c):
            switch rhs {
            case .highCard(let d):
                return c != d
            default:
                return true
            }
        case .onePair(let c):
            switch rhs {
            case .onePair(let d):
                return c != d
            default:
                return true
            }
        case .twoPair(let c):
            switch rhs {
            case .twoPair(let d):
                return c != d
            default:
                return true
            }
        case .threeOfAKind(let c):
            switch rhs {
            case .threeOfAKind(let d):
                return c != d
            default:
                return true
            }
        case .straight(let c):
            switch rhs {
            case .straight(let d):
                return c != d
            default:
                return true
            }
        case .flush(let c):
            switch rhs {
            case .flush(let d):
                return c != d
            default:
                return true
            }
        case .fullHouse(let c):
            switch rhs {
            case .fullHouse(let d):
                return c != d
            default:
                return true
            }
        case .fourOfAKind(let c):
            switch rhs {
            case .fourOfAKind(let d):
                return c != d
            default:
                return true
            }
        case .straightFlush(let c):
            switch rhs {
            case .straightFlush(let d):
                return c != d
            default:
                return true
            }
        default:
            fatalError("should not be here")
        }
    }
    
    static func >=(lhs: Hand, rhs: Hand) -> Bool {
        return !(lhs < rhs)
    }
    
    static func >(lhs: Hand, rhs: Hand) -> Bool {
        return !(lhs <= rhs)
    }
}
func getGeneric(_ hand: Hand) -> GenericHand {
    switch hand {
    case .highCard(_):
        return .highCard
    case .onePair(_):
        return .onePair
    case .twoPair(_):
        return .twoPair
    case .threeOfAKind(_):
        return .threeOfAKind
    case .straight(_):
        return .straight
    case .flush(_):
        return .flush
    case .fullHouse(_):
        return .fullHouse
    case .fourOfAKind(_):
        return .fourOfAKind
    case .straightFlush(_):
        return .straightFlush
    default:
        return .highCard
    }
}
enum GenericHand: Int {
    case straightFlush = 0, fourOfAKind, fullHouse, flush, straight, threeOfAKind, twoPair, onePair, highCard
}

func toString(hand: GenericHand) -> String {
    switch hand {
    case .straightFlush:
        return "Straight Flush"
    case .fourOfAKind:
        return "Four of a Kind"
    case .fullHouse:
        return "Full House"
    case .flush:
        return "Flush"
    case .straight:
        return "Straight"
    case .threeOfAKind:
        return "Three of a Kind"
    case .twoPair:
        return "Two Pair"
    case .onePair:
        return "One Pair"
    case .highCard:
        return "High Card"
    default:
        return ""
    }
}
