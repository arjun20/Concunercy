import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var value: Int = 20
let concurrentQueue = DispatchQueue(label: "com.queue.concurrent", attributes: .concurrent)

func doSyncTaskInConcurrentQueueQueue() {
        for i in 1...3 {
            concurrentQueue.sync {
            if Thread.isMainThread{
                print("task running in main thread")
            }else{
                print("task running in other thread")
            }
            let imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/0/07/Huge_ball_at_Vilnius_center.jpg")!
            let _ = try! Data(contentsOf: imageURL)
            print("\(i) finished downloading")
        }
    }
}

doSyncTaskInConcurrentQueueQueue()

concurrentQueue.async {
    for i in 1...3 {
        value = i
        print("\(value) ✴️")
    }
}

print("Last line in playground 🎉")
