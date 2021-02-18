//
//  ViewController.swift
//  GamerApp
//
//  Created by Raitis Saripo on 16/02/2021.
//

import UIKit
import Alamofire
import SwiftyJSON

class GamesListViewController: UIViewController {

    @IBOutlet weak var gamesTableView: UITableView!
    
    var gameManager = GameManager()
    var nextPageURL: String = ""
    
    //Data
    var games = [Game]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameManager.fetchData { (viewModelData, nextPage) in
    
            self.games = viewModelData
            self.nextPageURL = nextPage
            DispatchQueue.main.async {
                self.gamesTableView.reloadData()
            }
        }
        gamesTableView.dataSource = self
    }
    
    func raisePresentationView(with cellTag: Int?) {
        let presentationVC = InfoPresentationViewController()
        presentationVC.modalPresentationStyle = .custom
        presentationVC.transitioningDelegate = self
        if let indexPath = cellTag {
            presentationVC.gameName = games[indexPath].name
            presentationVC.coverURL = games[indexPath].background_image
            presentationVC.gameReleaseDate = games[indexPath].released
            presentationVC.gameRating = games[indexPath].rating
        }
        self.present(presentationVC, animated: true, completion: nil)
    }
    
    @IBAction func gameInfoButtonPressed(_ sender: UIButton) {
        raisePresentationView(with: sender.tag)
    }
}

//MARK: - Table View Data Source And Delegate Methods

extension GamesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let gameCell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! GameCell
        
        gameCell.accessoryType = .disclosureIndicator
        gameCell.loadGame(game: games[indexPath.row])
        
        gameCell.gameInfoButton.tag = indexPath.row

        
        return gameCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameVC = segue.destination as! GameViewController

        if let indexPath = gamesTableView.indexPathForSelectedRow {
            gameVC.coverImage = games[indexPath.row].background_image
            gameVC.gameName = games[indexPath.row].name
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.gameSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == games.count - 1 {
            
            //Add loading spinner
            tableView.tableFooterView = createLoadingSpinnder()
            
            gameManager.gameLibraryURL = self.nextPageURL
            gameManager.fetchData { (moreViewModelData, nextPage) in
                
                //Remove loading spinner
                tableView.tableFooterView = nil
                
                self.games.append(contentsOf: moreViewModelData)
                self.nextPageURL = nextPage
                DispatchQueue.main.async {
                    self.gamesTableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - Data Loading Spinner
    func createLoadingSpinnder() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let loadingSpinner = UIActivityIndicatorView()
        loadingSpinner.center = footerView.center
        footerView.addSubview(loadingSpinner)
        loadingSpinner.startAnimating()
        return footerView
    }
    
    
}

//MARK: - Presentation View Controller

extension GamesListViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
