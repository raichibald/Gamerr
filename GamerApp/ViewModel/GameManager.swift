//
//  GameManager.swift
//  GamerApp
//
//  Created by Raitis Saripo on 16/02/2021.
//

import Foundation
import UIKit
import Alamofire
import Kingfisher

struct GameManager {

    var gameLibraryURL = "https://api.rawg.io/api/games?key=\(K.apiKey)"
    
    func fetchData(completion: @escaping ([Game], String) -> ()) {
        AF.request(gameLibraryURL, method: .get).responseDecodable(of: GamesList.self) { (response) in
            switch response.result {
            case let .success(value):
                completion(value.results, value.next!)
            case let .failure(error):
                print(error)
            }
        }
    }
}
