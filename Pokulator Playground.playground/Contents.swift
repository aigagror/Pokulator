import Foundation

var count = 0

let c = [1,2,3,4,5]
let b = Array<Card>(repeating: Card(), count: 10)
c[1...4]
print(b[(2...6)])

//let workItem = DispatchWorkItem{
//    for i in 1...10 {
//        print("🔴 \(i)")
//        sleep(1)
//    }
//}
//
//let workItem2 = DispatchWorkItem{
//    for i in 1...10 {
//        print("🔵")
//        sleep(1)
//    }
//}
//
//let queue = DispatchQueue(label: "queue")
//queue.async {
//    workItem.perform()
//}
//
//
//
//sleep(5)
//queue.async {
//    workItem.perform()
//}
//sleep(10)

