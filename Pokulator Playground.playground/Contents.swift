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
    
    func test() -> Void {
        switch self {
        case .fourtOfAKind(let card):
            print(3)
        case .straight(let card):
            print(1)
        case .fullHouse(let card):
            print(2)
        default:
            print("hi")
        }
    }
}

let card = Card(value: 1, suit: 1)
let hand = Hand.fourtOfAKind(card)
hand.test()
struct Binomial {
    var n: Int
    var choose: Int
    init(n: Int, choose: Int) {
        self.n = n
        self.choose = choose
    }
    
    func _toDouble() -> Double {
        return 10.0/5.0
    }
}


func primes(_ input:Int) -> [Int]
{
    var n = input
    var answer:[Int] = []
    var z = 2
    
    while z * z <= n {
        if (n % z == 0) {
            answer.append(z)
            n /= z
        }
        else {
            z += 1
        }
    }
    if n > 1 {
        answer.append(n)
    }
    return answer
}

primes(15)


