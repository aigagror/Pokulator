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
    
    var deck = Array<Card>()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        for i in 1...52 {
            deck.append(Card(index: i))
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
