import Foundation

func hasAStraightFlush(cards: [Card?]) -> Int? {
    //Check if five of the cards are of the same suit
    
    var suitCount = [Suit.clubs : 0, Suit.diamonds : 0, Suit.hearts : 0, Suit.spades : 0]
    
    for card in cards {
        if let c = card {
            suitCount[c.suit]! += 1
        }
    }
    
    var possibleSuit: Suit? = nil
    for (suit, count) in suitCount {
        if count >= 5 {
            possibleSuit = suit
        }
    }
    
    if possibleSuit == nil {
        return nil
    }
    let validSuit = possibleSuit!
    
    //Check if those five cards are a straight
    var values = [Int]()
    for card in cards {
        if let c = card {
            if c.suit == validSuit {
                values.append(c.value)
            }
        }
    }
    assert(values.count >= 5)
    values.sort()
    for i in (4...values.count - 1).reversed() {
        var isStraight = true
        for j in i-4...i-1 {
            if values[j+1] - values[j] != 1{
                isStraight = false
                break
            }
        }
        if isStraight {
            return values[i]
        }
    }
    return nil
}
let c1 = Card(value: 1,suit: Suit.clubs)
let c2 = Card(value: 2,suit: Suit.spades)
let c3 = Card(value: 3,suit: Suit.clubs)
let c4 = Card(value: 4,suit: Suit.clubs)
let c5 = Card(value: 5,suit: Suit.hearts)
let c6 = Card(value: 6,suit: Suit.clubs)
let c7 = Card(value: 7,suit: Suit.diamonds)
let cards = [c2,c1,c4,c3,c7,c6,c5]

hasAStraightFlush(cards: cards)



