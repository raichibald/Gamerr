//
//  InfoPresentationView.swift
//  GamerApp
//
//  Created by Raitis Saripo on 17/02/2021.
//

import UIKit
import Kingfisher

class InfoPresentationViewController: UIViewController {
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    var gameName: String? = ""
    var coverURL: String? = ""
    var gameRating: Double? = 0
    var gameReleaseDate: String? = ""
    
    
    @IBOutlet weak var gameTitleLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameReleaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        gameTitleLabel.text = gameName
        
        if let gameCover = coverURL {
            gameImageView.kf.setImage(with: URL(string: gameCover))
        }
        
        if let rating = gameRating {
            ratingLabel.text = "User Rating: \(rating) / 5 ⭐️"
        }
        
        if let releaseDate = gameReleaseDate {
            gameReleaseDateLabel.text = "Release Date: \(releaseDate)"
        }
        
        //Image view
        gameImageView.layer.cornerRadius = 10
        gameImageView.clipsToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}
