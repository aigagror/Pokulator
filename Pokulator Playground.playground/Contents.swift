import Foundation


var deck = Array<Card>(arrayLiteral: Card(index: 1), Card(index: 2), Card(index: 3), Card(index: 4), Card(index: 5), Card(index: 6), Card(index: 7), Card(index: 8), Card(index: 9), Card(index: 10), Card(index: 11), Card(index: 12), Card(index: 13), Card(index: 14), Card(index: 15), Card(index: 16), Card(index: 17), Card(index: 18), Card(index: 19), Card(index: 20), Card(index: 21), Card(index: 22), Card(index: 23), Card(index: 24), Card(index: 25), Card(index: 26), Card(index: 27), Card(index: 28), Card(index: 29), Card(index: 30), Card(index: 31), Card(index: 32), Card(index: 33), Card(index: 34), Card(index: 35), Card(index: 36), Card(index: 37), Card(index: 38), Card(index: 39), Card(index: 40), Card(index: 41), Card(index: 42), Card(index: 43), Card(index: 44), Card(index: 45), Card(index: 46), Card(index: 47), Card(index: 48), Card(index: 49), Card(index: 50), Card(index: 51), Card(index: 52))

for i in 0...50 {
    for j in i+1...51 {
        if deck[i] == deck[j] {
            print("Fail!")
        }
    }
}
