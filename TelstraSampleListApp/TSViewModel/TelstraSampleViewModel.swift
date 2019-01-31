//
//  TelstraSampleViewModel.swift
//  TelstraSampleProject
//
//  Created by cts on 24/01/19.
//  Copyright © 2019 cts. All rights reserved.
//

import Foundation


//Setup my viewModel that inherits from NSObject
class TelstraSampleViewModel: NSObject {
    
    //Create an apiClient property that we can use to call on our API call
    var apiClient = TelstraSampleAPIClient()
    var jsontList: [NSDictionary]?
    var navTitle: String?
    //This function is what directly accesses the apiClient to make the API call
    func fetchJSONList(completion: @escaping () -> Void) {
        
        //call on the apiClient to fetch the apps
        apiClient.fetchJSONList { (arrayOfJSONListDictionaries,title) in
            
            //Put this block on the main queue because our completion handler is where the data display code will happen and we don't want to block any UI code.
            DispatchQueue.main.async {
                self.jsontList = arrayOfJSONListDictionaries?.filter({ (dictionaryItem  ) -> Bool in
                    for value in dictionaryItem.allValues {
                        if let _ = value as? String {
                            return true
                        }
                    }
                    return false
                })
                self.navTitle = title
                completion()
            }
        }
    }
    
    //fetching navigation title
    func titleToDisplay() -> String? {
        return navTitle
    }

    //values to display in our table view
    func numberOfItemsToDisplay(in section: Int) -> Int {
        return jsontList?.count ?? 0
    }
    
    func imagesURLToDisplay(for indexPath: IndexPath) -> String {
        return jsontList?[indexPath.row].value(forKeyPath: Contants.imageRef) as? String ?? ""
    }
    
    func appTitleToDisplay(for indexPath: IndexPath) -> String {
        return jsontList?[indexPath.row].value(forKeyPath: Contants.title) as? String ?? ""
    }
    
    func appDescriptionToDisplay(for indexPath: IndexPath) -> String {
        return jsontList?[indexPath.row].value(forKeyPath: Contants.description) as? String ?? ""
    }
    
    
    
}
