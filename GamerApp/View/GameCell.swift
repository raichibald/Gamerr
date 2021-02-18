//
//  GameCell.swift
//  GamerApp
//
//  Created by Raitis Saripo on 16/02/2021.
//

import UIKit
import Kingfisher

class GameCell: UITableViewCell {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var gameInfoButton: UIButton!
    
    func loadGame(game: Game) {
        gameLabel.text = game.name
        
        if let releaseDate = game.released {
            releaseDateLabel.text = "Released: \(releaseDate)"
        }
        
        if let gameCover = game.background_image {
            gameImageView.kf.setImage(with: URL(string: gameCover))
        }
        
        //Image view
        gameImageView.layer.cornerRadius = 10
        gameImageView.clipsToBounds = true
        
        //Button
        gameInfoButton.layer.cornerRadius = 7
    }
}
