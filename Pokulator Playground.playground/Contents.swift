import Foundation

var count = 0

let workItem = DispatchWorkItem{
    for i in 1...10 {
        print("🔴 \(i)")
        sleep(1)
    }
}

let workItem2 = DispatchWorkItem{
    for i in 1...10 {
        print("🔵")
        sleep(1)
    }
}

let queue = DispatchQueue(label: "queue")
queue.async {
    workItem.perform()
}



sleep(5)
queue.async {
    workItem.perform()
}
sleep(10)

