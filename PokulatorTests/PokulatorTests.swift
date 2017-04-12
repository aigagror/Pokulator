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
    
    
    var cardSets = [Hand : [[Card?]]]()
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        //Initializing card reference for easy access
        var card_ref = Array<Array<Card>>(repeating: Array<Card>(repeating: Card(value: 1, suit: .clubs), count: 4), count: 14)
        for i in 1...13 {
            for j in 0...3 {
                card_ref[i][j] = Card(value: i, suit: j)
            }
        }
        
        var straightFlushTestCards = [[Card?]]()
        let sftc1 = [card_ref[3][0], card_ref[2][0], card_ref[5][0], card_ref[4][0], card_ref[6][0]]
        let sftc2 = [card_ref[12][0], card_ref[0][0], card_ref[11][0], card_ref[10][0], card_ref[9][0]]
        
        straightFlushTestCards.append(sftc1)
        straightFlushTestCards.append(sftc2)
        cardSets[Hand.straightFlush(1)] = straightFlushTestCards
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStaightFlushDetection() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let sftc = cardSets[Hand.straightFlush(1)]
        print(hasAStraightFlush(cards: sftc![0]) ?? "nil")
        XCTAssert(hasAStraightFlush(cards: sftc![0]) == 6)
        XCTAssert(hasAStraightFlush(cards: sftc![1]) == 1)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
