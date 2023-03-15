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
    @IBOutlet weak var collectionView: UICollectionView!
    
    var delegate: DetailsViewControllerDelegate?
    var companyName: String = ""
    var ticker: String = ""
    var isTickerFavourite: Bool = false
    var collectionViewButtons: [collectionVButton] = [
        collectionVButton(text: "Chart", font: UIFont(name: "Montserrat-Bold", size: 18)!, textColor: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)),
        collectionVButton(text: "Summary", font: UIFont(name: "Montserrat-SemiBold", size: 14)!, textColor: UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1.0)),
        collectionVButton(text: "News", font: UIFont(name: "Montserrat-SemiBold", size: 14)!, textColor: UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1.0)),
        collectionVButton(text: "Forecasts", font: UIFont(name: "Montserrat-SemiBold", size: 14)!, textColor: UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1.0)),
        collectionVButton(text: "Ideas", font: UIFont(name: "Montserrat-SemiBold", size: 14)!, textColor: UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1.0))]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        titleLabel.text = ticker
        promptLabel.text = companyName
        if isTickerFavourite == true {
            starButton.tintColor = UIColor(red: 1.0, green: 0.79, blue: 0.11, alpha: 1.0)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: Constants.detailsCellNibName, bundle: nil), forCellWithReuseIdentifier: Constants.detailsCellIdentifier)
        
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

//MARK: - CollectionView DataSource Methods

extension DetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionViewButtons.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.detailsCellIdentifier, for: indexPath) as! DetailsCollectionViewCell
        
        cell.button.setTitle(collectionViewButtons[indexPath.row].text, for: .normal)
        cell.button.setTitleColor(collectionViewButtons[indexPath.row].textColor, for: .normal)
        cell.button.titleLabel?.font = collectionViewButtons[indexPath.row].font
        
        return cell
        
    }
    
}

//MARK: - Collection View Delegate Flow Layout Methods

extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 20
        
    }
    
}
