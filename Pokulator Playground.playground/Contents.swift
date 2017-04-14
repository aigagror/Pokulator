import Foundation

let numberOfCards = 4

Binom(n: numberOfCards, choose: 1).toInt()

Binom(n: numberOfCards, choose: 1) * Binom(n: 3, choose: 1) * Binom(n: 13 - numberOfCards, choose: 6 - numberOfCards)

Binom(n: 13, choose: 1) * Binom(n: 4, choose: 2) * Binom(n: 12, choose: 5) * pow(Binom(n: 4, choose: 1).toInt(), 5)

Binom(n: 52, choose: 7).toInt()

Binom(n: 11, choose: 4).toInt()

Binom(n: 4, choose: 1).toInt()

Binom(n: 12, choose: 1) * Binom(n: 4, choose: 2) * Binom(n: 11, choose: 4) * pow(Binom(n: 4, choose: 1).toInt(), 4)

