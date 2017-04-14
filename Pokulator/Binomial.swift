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
    private var n: Int
    private var c: Int
    init(n: Int, choose: Int) {
        guard(n > 0 && choose >= 0) else {
            fatalError("bad binom input")
        }
        guard(n >= choose) else {
            fatalError("bad binom input")
        }
        self.n = n
        self.c = choose
    }
    
    func toInt() -> Int {
        // n! / c! / (n-c)!
        if c == 0 || c == n {
            return 1
        }
        
        let g = max(c, n-c)
        let l = min(c, n-c)
        var numerator: Int  {
            var prod = 1
            for i in g+1...n {
                prod *= i
            }
            return prod
        }
        
        var denominator: Int {
            var prod = 1
            for i in 1...l {
                prod *= i
            }
            return prod
        }
        
        guard numerator % denominator == 0 else {
            fatalError("Binom about to return a fraction")
        }
        return numerator / denominator
    }
    
    static func *(left: Binom, right: Binom) -> Int {
        return left.toInt() * right.toInt()
    }
    
    static func *(left: Int, right: Binom) -> Int {
        return left * right.toInt()
    }
    
    static func *(left: Binom, right: Int) -> Int {
        return left.toInt() * right
    }
    
    static func /(left: Int, right: Binom) -> Double {
        return Double(left) / Double(right.toInt())
    }
    
    static func /(left: Binom, right: Binom) -> Double {
        return Double(left.toInt()) / Double(right.toInt())
    }
}
