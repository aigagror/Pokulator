import Foundation

func hasAFullHouse(cards: [Card?]) -> Int? {
    var valuesCount = Array<Int>(repeating: 0, count: 13)
    for card in cards {
        if let c = card {
            valuesCount[c.value-1] += 1
        }
    }
    var has3OfAKind: Int? = nil
    var hasAPair: Int? = nil
    for i in 0...12 {
        if valuesCount[i] >= 3 {
            if has3OfAKind != nil {
                if i+1 > has3OfAKind! {
                    hasAPair = has3OfAKind
                    has3OfAKind = i+1
                } else {
                    hasAPair = i+1
                }
            } else {
                has3OfAKind = i+1
            }
        } else if valuesCount[i] >= 2 {
            hasAPair = i+1
        }
    }
    if has3OfAKind != nil && hasAPair != nil {
        return has3OfAKind
    } else {
        return nil
    }
}

let c1 = Card(value: 1,suit: Suit.clubs)
let c2 = Card(value: 7,suit: Suit.spades)
let c3 = Card(value: 7,suit: Suit.clubs)
let c4 = Card(value: 7,suit: Suit.diamonds)
let c5 = Card(value: 6,suit: Suit.hearts)
let c6 = Card(value: 6,suit: Suit.clubs)
let c7 = Card(value: 6,suit: Suit.diamonds)
let cards = [c2,c1,c4,c3,c7,c6,c5]

hasAFullHouse(cards: cards)


