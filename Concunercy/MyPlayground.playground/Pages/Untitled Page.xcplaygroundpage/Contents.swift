import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

let parameters = "{\n    \"reference_id\": \"0000-0000-0000-0019\",\n    \"purpose_message\": \"This is a penny drop transaction\",\n    \"transfer_amount\": \"1.5\",\n    \"validation_type\":\"pennydrop\",\n    \"beneficiary_details\": {\n        \"account_number\": \"001128907346285\",\n        \"ifsc\": \"ALLA0CBCBCBB\"\n    }\n}"
let postData = parameters.data(using: .utf8)

let josn = ["reference_id": "0000-0000-0000-0033", "purpose_message": "This is a penny drop transaction", "transfer_amount": "1.5", "validation_type": "pennydrop", "beneficiary_details": ["account_number":"001128907346285","ifsc":"ALLA0CBCBCBB"]] as [String : Any]

//let data: NSData = NSKeyedArchiver.archivedData(withRootObject: josn)  as NSData

var request = URLRequest(url: URL(string: "https://in.staging.decentro.tech/core_banking/money_transfer/validate_account")!,timeoutInterval: Double.infinity)
request.addValue("MobileFirstApplication_5_sop", forHTTPHeaderField: "client_id")
request.addValue("bc9426010a6c42149af54432a505a47b", forHTTPHeaderField: "client_secret")
request.addValue("41759d2cf73b4baf84be8527fc9e862d", forHTTPHeaderField: "module_secret")
request.addValue("e8b334ada7b548048fde140753d68294", forHTTPHeaderField: "provider_secret")

//request.addValue("ea814bfd59ae4f18ae81d08655e7ad34", forHTTPHeaderField: "module_secret")
//request.addValue("2555f039398b4845a077e85daf95e07e", forHTTPHeaderField: "provider_secret")
request.addValue("application/json", forHTTPHeaderField: "Content-Type")

request.httpMethod = "POST"
//request.httpBody =
request.httpBody = try? JSONSerialization.data(withJSONObject: josn) // data // postData

let task = URLSession.shared.dataTask(with: request) { data, response, error in
  guard let data = data else {
    print(String(describing: error))
    return
  }
  print(String(data: data, encoding: .utf8)!)
}

task.resume()

