import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
//            ///First Code
//        print("About to being opration")
//        testOpration()
//        print("Opration Executed")
        
        
//        /// Second Code
//        let opration: CustomeOpration = CustomeOpration()
//        opration.start()
//        print("Custome Opration Executed")
        
        
        
//        ///Third Code
        testOpration2()
    }
    
    func testOpration() {
        let opration: BlockOperation = BlockOperation()
        opration.addExecutionBlock {
            print("First Block Executed")
        }
        
        opration.addExecutionBlock {
            print("Second Block Executed")
        }
        
        opration.addExecutionBlock {
            print("Thrid Block Executed")
        }
        
        opration.addExecutionBlock {
            print("Fourth Block Executed")
        }

        
        DispatchQueue.global().async {
            opration.start()
            print("Did This Run Main Thread :\(Thread.isMainThread)")

        }
    }
    
    func testOpration2() {
        let opration: BlockOperation = BlockOperation()
        opration.addExecutionBlock {
            print("First Block Being Executed")
            for i in 0...10 {
               print(i)
            }

        }
        
        opration.completionBlock = {
            print("First Block Executed")
        }
       
        let opration1: BlockOperation = BlockOperation()
        opration1.addExecutionBlock {
            print("Second Block Being Executed")
            for i in 11...20 {
               print(i)
            }

        }
        
        opration1.completionBlock = {
            print("Second Block Executed")
        }
        
        let oprationQueue: OperationQueue = OperationQueue()
        oprationQueue.maxConcurrentOperationCount = 1
        oprationQueue.addOperation(opration)
        oprationQueue.addOperation(opration1)
        
        //set dipendency
//        opration1.addDependency(opration)

    }
}


class CustomeOpration: Operation {
    override func start() {
        Thread.init(block: main).start()
    }
    override func main() {
        for i in 0...10 {
           print(i)
        }
    }
}
