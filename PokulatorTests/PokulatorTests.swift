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
        let set  = Set<Card>(arrayLiteral: Card(value: 1, suit: 0), Card(value: 1, suit: 1))
//        XCTAssertEqual(numValidRankSets(cards: set), Binom(n: 12, choose: 5) - 2 - (6 + 7 + 7))
//        XCTAssertEqual(numValidSuitSets(cards: set), 990)
        XCTAssertEqual(probOnePair(cards: empty), 58627800 / Binom(n: 52, choose: 7))
    }
    
    func testStaightFlushDetection() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let c1 = Set<Card>(arrayLiteral: Card(value: 2, suit: .clubs), Card(value: 3, suit: .clubs), Card(value: 4, suit: .clubs), Card(value: 5, suit: .clubs), Card(value: 6, suit: .clubs))
        let c2 = Set<Card>(arrayLiteral: Card(value: 1, suit: .clubs), Card(value: 10, suit: .clubs), Card(value: 11, suit: .clubs), Card(value: 12, suit: .clubs), Card(value: 13, suit: .clubs), Card(value: 10, suit: .clubs))
        XCTAssertEqual(hasAStraightFlush(cards: c1), Hand.straightFlush(6))
        XCTAssertEqual(hasAStraightFlush(cards: c2), Hand.straightFlush(1))
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
