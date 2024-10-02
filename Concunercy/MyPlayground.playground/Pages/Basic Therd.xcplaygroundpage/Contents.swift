import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

var counter = 1

///Below code in used async manner so its manes deos not blocked current executiation and its runnung saperatly.
DispatchQueue.main.async {
    for i in 0...3 {
        counter = i
        print("\(counter)")
    }
}

/// No Block for below code, so its exctution directly. 
for i in 4...6 {
    counter = i
    print("\(counter)")
}

///Below code in used async manner so its manes deos not blocked current executiation and its runnung saperatly.
DispatchQueue.main.async {
    counter = 9
    print(counter)
}
