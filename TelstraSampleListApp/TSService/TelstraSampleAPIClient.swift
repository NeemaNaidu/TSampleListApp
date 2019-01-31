//
//  TelstraSampleAPIClient.swift
//  TelstraSampleProject
//
//  Created by cts on 24/01/19.
//  Copyright © 2019 cts. All rights reserved.
//

import Foundation


//This APIClient will be called by the viewModel to get our top 100 app data.
class TelstraSampleAPIClient: NSObject {
    
    //the completion handler will be executed after our top 100 app data is fetched
    // our completion handler will include an optional array of NSDictionaries parsed from our retrieved JSON object
    func fetchJSONList(completion: @escaping ([NSDictionary]?,String?) -> Void) {
        
        //unwrap our API endpoint
        guard let url = URL(string: Contants.baseUrl) else {
            print("Error unwrapping URL"); return }
        
        //create a session and dataTask on that session to get data/response/error
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            //unwrap our returned data
            guard let unwrappedData = data else { print("Error getting data"); return }
            
            
            let encodedCharacterStr = String(data: unwrappedData, encoding: String.Encoding.isoLatin1)
            guard let modifiedDataInUTF8Format = encodedCharacterStr?.data(using: String.Encoding.utf8) else {
                print("could not convert data to UTF-8 format")
                return
            }
            do {
                //create an object for our JSON data and cast it as a NSDictionary
                if let responseJSON = try JSONSerialization.jsonObject(with: modifiedDataInUTF8Format as Data, options: .allowFragments) as? NSDictionary {
                    
                    //set the completion handler with our apps array of dictionaries
                    let result = responseJSON.value(forKeyPath: "rows") as? [NSDictionary]
                    
                    let navTitle = responseJSON.value(forKeyPath: "title") as? String
                    completion(result,navTitle)
                }
            } catch {
                //if we have an error, set our completion with nil
                completion(nil,"")
                print("Error getting API data: \(error.localizedDescription)")
            }
        }
        dataTask.resume()
    }
    
}
