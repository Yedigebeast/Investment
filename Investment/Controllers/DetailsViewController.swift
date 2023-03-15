//
//  DetailsViewController.swift
//  Investment
//
//  Created by Yedige Ashirbek on 26.02.2023.
//

import UIKit

protocol DetailsViewControllerDelegate {
    
    func didUpdateFavouriteButton(isTickerFavourite: Bool, ticker: String)
    
}

class DetailsViewController: UIViewController {
        
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var promptLabel: UILabel!
    
    var delegate: DetailsViewControllerDelegate?
    var companyName: String = ""
    var ticker: String = ""
    var isTickerFavourite: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        titleLabel.text = ticker
        promptLabel.text = companyName
        if isTickerFavourite == true {
            starButton.tintColor = UIColor(red: 1.0, green: 0.79, blue: 0.11, alpha: 1.0)
        }
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        delegate?.didUpdateFavouriteButton(isTickerFavourite: isTickerFavourite, ticker: ticker)
        self.dismiss(animated: false)
        
    }
    
    
    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        
        if isTickerFavourite == false {
            starButton.tintColor = UIColor(red: 1.0, green: 0.79, blue: 0.11, alpha: 1.0)
        } else {
            starButton.tintColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        }
        isTickerFavourite = !isTickerFavourite
        
    }
    
}
