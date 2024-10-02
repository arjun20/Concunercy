import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

DispatchQueue.main.async {
    print(Thread.isMainThread ? "Execution On Main Thread" : "Execution On Other Thread")
}

DispatchQueue.global().async {
    print(Thread.isMainThread ? "Execution On Main Thread" : "Execution On Global Concurrent Queue")

}
