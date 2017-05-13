//
//  PokulatorTests.swift
//  PokulatorTests
//
//  Created by Edward Huang on 4/11/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import XCTest
@testable import Pokulator
class PokulatorTests: XCTestCase {
    
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBinomials() {
        XCTAssert(Binom(n: 5, choose: 2).toInt() == 10)
        XCTAssert(Binom(n: 10, choose: 4) * Binom(n: 4, choose: 0) * Binom(n: 7, choose: 1) * Binom(n: 8, choose: 4) == 102900)
    }
    
    func testOnePairProb() -> Void {
        let empty = Set<Card>()
//        let set  = Set<Card>(arrayLiteral: Card(value: 1, suit: 0), Card(value: 1, suit: 1))
//        XCTAssertEqual(numValidRankSets(cards: set), Binom(n: 12, choose: 5) - 2 - (6 + 7 + 7))
//        XCTAssertEqual(numValidSuitSets(cards: set), 990)
        XCTAssertEqual(probOnePair(cards: empty), 58627800 / Binom(n: 52, choose: 7))
    }
    
    func testTwoPairProb() -> Void {
        let empty = Set<Card>()
        XCTAssertEqual(probTwoPair(cards: empty), 31_433_400 / Binom(n: 52, choose: 7))
    }
    
    func testHandDetection() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let sf = Array<Card>(arrayLiteral: Card(value: 2, suit: .clubs), Card(value: 3, suit: .clubs), Card(value: 4, suit: .clubs), Card(value: 5, suit: .clubs), Card(value: 6, suit: .clubs))
        let sf2 = Array<Card>(arrayLiteral: Card(value: 1, suit: .clubs), Card(value: 10, suit: .clubs), Card(value: 11, suit: .clubs), Card(value: 12, suit: .clubs), Card(value: 13, suit: .clubs), Card(value: 10, suit: .spades))
        XCTAssertEqual(getGeneric(getCurrentKnownHand(cards: sf)), GenericHand.straightFlush)
        XCTAssertEqual(getGeneric(getCurrentKnownHand(cards: sf2)), GenericHand.straightFlush)
    }
    
    func testDeck() -> Void {
        let deck = Array<Card>(arrayLiteral: Card(index: 1), Card(index: 2), Card(index: 3), Card(index: 4), Card(index: 5), Card(index: 6), Card(index: 7), Card(index: 8), Card(index: 9), Card(index: 10), Card(index: 11), Card(index: 12), Card(index: 13), Card(index: 14), Card(index: 15), Card(index: 16), Card(index: 17), Card(index: 18), Card(index: 19), Card(index: 20), Card(index: 21), Card(index: 22), Card(index: 23), Card(index: 24), Card(index: 25), Card(index: 26), Card(index: 27), Card(index: 28), Card(index: 29), Card(index: 30), Card(index: 31), Card(index: 32), Card(index: 33), Card(index: 34), Card(index: 35), Card(index: 36), Card(index: 37), Card(index: 38), Card(index: 39), Card(index: 40), Card(index: 41), Card(index: 42), Card(index: 43), Card(index: 44), Card(index: 45), Card(index: 46), Card(index: 47), Card(index: 48), Card(index: 49), Card(index: 50), Card(index: 51), Card(index: 52))
        
        for i in 0...50 {
            for j in i+1...51 {
                if deck[i] == deck[j] {
                    XCTFail()
                }
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
