//
//  GameViewController.swift
//  GamerApp
//
//  Created by Raitis Saripo on 17/02/2021.
//

import UIKit
import Kingfisher

class GameViewController: UIViewController {
    
    var coverImage: String? = ""
    var gameName: String? = ""
    
    let gameDetailsManager = GameDetailsManager()

    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameDescriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let gameTitle = gameName {
            self.title = gameTitle
            gameDetailsManager.fetchData(gameName: gameTitle) { (gameData) in
                self.gameDescriptionLabel.text = gameData
            }
        }
        
        if let gameCover = coverImage {
            gameImageView.kf.setImage(with: URL(string: gameCover))
        }
    }
}
