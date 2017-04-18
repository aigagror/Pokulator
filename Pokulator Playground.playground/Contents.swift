import Foundation

let start = Date()
let dictionary = monte_carlo(cards: Set<Card>(), n: 200_000)

let elapsed = -start.timeIntervalSinceNow

print("Took \(elapsed) seconds")

for i in (0...8).reversed() {
    print(dictionary[GenericHand(rawValue: i)!]!)
}



