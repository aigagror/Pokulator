//
//  Binomial.swift
//  Pokulator
//
//  Created by Edward Huang on 4/8/17.
//  Copyright © 2017 Eddie Huang. All rights reserved.
//

import Foundation


/// Choose notation
struct Binom {
    var n: Int
    var c: Int
    init(n: Int, choose: Int) {
        self.n = n
        self.c = choose
    }
    
    func toInt() -> Int {
        
    }
    
    static func *(left: Binom, right: Binom) -> Int {
        return
    }
}
