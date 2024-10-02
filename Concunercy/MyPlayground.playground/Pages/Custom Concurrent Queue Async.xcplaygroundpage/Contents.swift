import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let customeQueueA: DispatchQueue = DispatchQueue(label: "First")
let customeQueueB: DispatchQueue = DispatchQueue(label: "Second", attributes: .concurrent, target: customeQueueA)

customeQueueA.async {
    for i in 0...5 {
        print(i)
    }
}

customeQueueA.async {
    for i in 6...10 {
        print(i)
    }
}

customeQueueB.async {
    for i in 11...15 {
        print(i)
    }
}

customeQueueB.async {
    for i in 16...20 {
        print(i)
    }
}


/////////////////////////////////
let a: DispatchQueue = DispatchQueue(label: "a")
//let b: DispatchQueue = DispatchQueue(label: "b")
let b: DispatchQueue = DispatchQueue(label: "b", attributes: [.concurrent, .initiallyInactive])

b.setTarget(queue: a)
b.activate()
