//
//  NetworkManager.swift
//  AssessmentTest
//
//  Created by Viabhav Powar on 23/05/22.
//

import Foundation

class NetworkManager {
    static let instance = NetworkManager()
    
    //MARK: GET SERVICE API
    func getprice(completion: @escaping(priceChange?, Error?) -> ()) {
        
        guard ConnectionManager.shared.hasConnectivity() else{
            return  
        }
        guard let url = URL(string: "https://qapptemporary.s3.ap-south-1.amazonaws.com/test/gainer_loser.json") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                debugPrint(error.debugDescription)
                completion(nil, error)
                return
            } else {
                guard let data = data else {return completion(nil, error)}
                let decoder = JSONDecoder()
                
                do{
                    let returnedResponse = try decoder.decode(priceChange.self, from: data)
                    completion(returnedResponse, nil)
                    print(returnedResponse)
                }catch{
                    debugPrint(error.localizedDescription)
                    completion(nil, error)
                    return
                }
            }
            
        }
        task.resume()
    }
    
}
    

