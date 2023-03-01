//
//  ViewController.swift
//  Investment
//
//  Created by Yedige Ashirbek on 13.02.2023.
//

import UIKit
import Kingfisher
import SVGKit

class ViewController: UIViewController {

    var companyManager = CompanyManager()
    var companies: [Company] = []
    var favourites: [String : Bool] = [:]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        companyManager.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 68
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        for ticker in companyManager.tickersOfCompanies {
            
            companyManager.tickerSelected = ticker
            companyManager.getTickerInfo()
            
        }
                
    }

    @IBAction func StocksButtonPressed(_ sender: UIButton) {
    
        
        
    }
    
    @IBAction func FavouriteButtonPressed(_ sender: UIButton) {
        
        
   
    }
    
}

//MARK: - TableView DataSource Methods

extension ViewController: UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return companies.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) as! CompanyCell
        
        cell.delegate = self
        cell.favouriteButton.tag = indexPath.row
        cell.layer.cornerRadius = cell.frame.size.height / 4
        
        cell.companyName.text = companies[indexPath.row].companyName
        cell.label.text = companies[indexPath.row].ticker
        
        print(companies[indexPath.row].ticker, " ", favourites[companies[indexPath.row].ticker])
        print("That is all bro")
        
        if favourites[companies[indexPath.row].ticker] == true {
            
            cell.favouriteButton.imageView?.image = UIImage(named: "Like")
            
        } else {
            
            cell.favouriteButton.imageView?.image = UIImage(named: "Hate")
            
        }
        
        if indexPath.row % 2 == 0 {
            
            cell.backgroundColor = UIColor(red: 0.94, green: 0.96, blue: 0.97, alpha: 1.0)

        } else {
            
            cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            
        }
        
            
        let url = URL(string: companies[indexPath.row].imageLink)!
        let file = companies[indexPath.row].imageLink.suffix(3)
        
        if file == "svg" {
            
            cell.companyImage.downloadedsvg(from: url)
            
        } else {
            
            cell.companyImage.kf.setImage(with: url)
            
        }
                
        return cell
        
    }
    
}

//MARK: - TableView Delegate Methods

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: Constants.segueIdentifier, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Constants.segueIdentifier {
            
            
            
        }
        
    }
    
}

//MARK: - CompanyManager Delegate Methods

extension ViewController: CompanyManagerDelegate {
    
    func didUpdateCompany(_ companyManager: CompanyManager, company: Company) {
        
        DispatchQueue.main.async {
                        
            self.companies.append(Company(ticker: company.ticker, companyName: company.companyName, imageLink: company.imageLink))
            
            if self.companies.count == companyManager.tickersOfCompanies.count {
                
                self.tableView.reloadData()
                
            }
            
        }
        
    }
    
    func didFailWithError(error: Error) {
        
        print(error)
        
    }
    
}

//MARK: - CompanyCell Delegate

extension ViewController: CompanyCellDelegate {
    
    func cellFavouriteButtonPressed(tag: Int) {
                
        if favourites[companies[tag].ticker] == true {
            
            favourites[companies[tag].ticker] = false
            
        } else {
            
            favourites[companies[tag].ticker] = true
            
        }
        
        print(favourites)
        
        tableView.reloadData()
        
    }
    
}




//MARK: - Download SVG image

extension UIImageView {
    func downloadedsvg(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let receivedicon: SVGKImage = SVGKImage(data: data),
                let image = receivedicon.uiImage
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
}
