//
//  GameDetailsManager.swift
//  GamerApp
//
//  Created by Raitis Saripo on 17/02/2021.
//

import Foundation
import Alamofire
import SwiftyJSON

struct GameDetailsManager {
    let wikiURL = "https://en.wikipedia.org/w/api.php"
    
    func fetchData(gameName: String, completion: @escaping (String) -> ()) {
        let parameters : [String:String] = [
            "format" : "json",
            "action" : "query",
            "prop" : "extracts",
            "exintro" : "",
            "explaintext" : "",
            "titles" : gameName,
            "indexpageids" : "",
            "redirects" : "1",
            "pithumbsize" : "500"
        ]
        
        AF.request(wikiURL, method: .get, parameters: parameters).responseJSON { (response) in
            
            switch response.result {
            case let .success(value):
                let gameDetailsJSON: JSON = JSON(value)
                let pageID = gameDetailsJSON["query"]["pageids"][0].stringValue
                let gameDescription = gameDetailsJSON["query"]["pages"][pageID]["extract"].stringValue

                completion(gameDescription)
            case let .failure(error):
                print(error)
            }
        }
    }
}
