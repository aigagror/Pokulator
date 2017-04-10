import Foundation

struct Factors {
    
}


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


