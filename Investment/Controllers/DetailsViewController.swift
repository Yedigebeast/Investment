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
    @IBOutlet weak var separatorLine: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changeInPriceLabel: UILabel!
    @IBOutlet weak var chipsCollectionView: UICollectionView!
    @IBOutlet weak var buyButton: UIButton!
    
    var delegate: DetailsViewControllerDelegate?
    var companyName: String = ""
    var ticker: String = ""
    var price: String = ""
    var changeInPrice: String = ""
    var isTickerFavourite: Bool = false
    
    var collectionViewButtons: [collectionVButton] = [
        collectionVButton(text: "Chart", font: UIFont(name: "Montserrat-Bold", size: 18)!, textColor: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)),
        collectionVButton(text: "Summary", font: UIFont(name: "Montserrat-SemiBold", size: 14)!, textColor: UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1.0)),
        collectionVButton(text: "News", font: UIFont(name: "Montserrat-SemiBold", size: 14)!, textColor: UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1.0)),
        collectionVButton(text: "Forecasts", font: UIFont(name: "Montserrat-SemiBold", size: 14)!, textColor: UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1.0)),
        collectionVButton(text: "Ideas", font: UIFont(name: "Montserrat-SemiBold", size: 14)!, textColor: UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1.0))]
    
    var chipsViewButtons: [ChipsVButton] = [ChipsVButton(text: "D", backgroundColor: UIColor(red: 0.94, green: 0.96, blue: 0.97, alpha: 1.0), textColor: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)),
        ChipsVButton(text: "W", backgroundColor: UIColor(red: 0.94, green: 0.96, blue: 0.97, alpha: 1.0), textColor: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)),
        ChipsVButton(text: "M", backgroundColor: UIColor(red: 0.94, green: 0.96, blue: 0.97, alpha: 1.0), textColor: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)),
        ChipsVButton(text: "6M", backgroundColor: UIColor(red: 0.94, green: 0.96, blue: 0.97, alpha: 1.0), textColor: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)),
        ChipsVButton(text: "1Y", backgroundColor: UIColor(red: 0.94, green: 0.96, blue: 0.97, alpha: 1.0), textColor: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)),
        ChipsVButton(text: "All", backgroundColor: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0), textColor: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        titleLabel.text = ticker
        promptLabel.text = companyName
        priceLabel.text = price
        changeInPriceLabel.text = changeInPrice
        if isTickerFavourite == true {
            starButton.tintColor = UIColor(red: 1.0, green: 0.79, blue: 0.11, alpha: 1.0)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Constants.detailsCellNibName, bundle: nil), forCellWithReuseIdentifier: Constants.detailsCellIdentifier)
        collectionView.tag = 0
        
        chipsCollectionView.delegate = self
        chipsCollectionView.dataSource = self
        chipsCollectionView.register(UINib(nibName: Constants.chipsCellNibName, bundle: nil), forCellWithReuseIdentifier: Constants.chipsCellIdentifier)
        chipsCollectionView.tag = 1
        
        buyButton.layer.cornerRadius = 16
        buyButton.setTitle("Buy for \(price)", for: .normal)
        
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
        
        if collectionView.tag == 0 {
            
            return collectionViewButtons.count
            
        } else {
            
            return chipsViewButtons.count
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 0 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.detailsCellIdentifier, for: indexPath) as! DetailsCollectionViewCell
            
            cell.button.tag = indexPath.row
            cell.delegate = self
            
            cell.label.sizeToFit()
            cell.label.text = collectionViewButtons[indexPath.row].text
            cell.label.textColor = collectionViewButtons[indexPath.row].textColor
            cell.label.font = collectionViewButtons[indexPath.row].font
            
            return cell
            
        } else {
            
            let cell = chipsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.chipsCellIdentifier, for: indexPath) as! ChipsCell
            
            cell.button.tag = indexPath.row
            cell.delegate = self
            
            cell.layer.cornerRadius = 12
            cell.label.text = chipsViewButtons[indexPath.row].text
            cell.contentView.backgroundColor = chipsViewButtons[indexPath.row].backgroundColor
            cell.label.textColor = chipsViewButtons[indexPath.row].textColor
                    
            return cell
            
        }
        
    }
    
}

//MARK: - Collection View Delegate Flow Layout Methods

extension DetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        if collectionView.tag == 0 {
            
            return 20
            
        } else {
            
            return 16.8
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView.tag == 0 {
            
            return CGSize(width: collectionViewButtons[indexPath.row].text.getStringwidth(height: 24, font: collectionViewButtons[indexPath.row].font), height: 24)
            
        } else {
            
            return CGSize(width: chipsViewButtons[indexPath.row].text.getStringwidth(height: 16, font: UIFont(name: "Montserrat-Semibold", size: 12)!) + 32, height: 44)
            
        }
        
    }
    
}

//MARK: - Details Collection View Cell Delegate Methods

extension DetailsViewController: DetailsCollectionViewCellDelegate {

    func didButtonPressed(tag: Int) {

        for i in 0..<collectionViewButtons.count {

            collectionViewButtons[i].font = UIFont(name: "Montserrat-SemiBold", size: 14)!
            collectionViewButtons[i].textColor = UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1.0)

        }

        collectionViewButtons[tag].font = UIFont(name: "Montserrat-Bold", size: 18)!
        collectionViewButtons[tag].textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        collectionView.reloadData()

    }

}

//MARK: - Chips Cell Delegate Methods

extension DetailsViewController: ChipsCellDelegate {

    func didChipsButtonPressed(tag: Int) {

        for i in 0..<chipsViewButtons.count {
            
            chipsViewButtons[i].backgroundColor = UIColor(red: 0.94, green: 0.96, blue: 0.97, alpha: 1.0)
            chipsViewButtons[i].textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)

        }

        chipsViewButtons[tag].backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        chipsViewButtons[tag].textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        chipsCollectionView.reloadData()

    }


}
