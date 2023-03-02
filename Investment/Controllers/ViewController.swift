//
//  ViewController.swift
//  Investment
//
//  Created by Yedige Ashirbek on 13.02.2023.
//

import UIKit
import Kingfisher
import SVGKit
import CoreData

class ViewController: UIViewController {

    var companyManager = CompanyManager()
    var companies: [Company] = []
    var favourites = [Favourite]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var chosedStocksButton = true
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var stocksButton: UIButton!
    
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
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        companyManager.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = 68
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        loadItems()
                
        companyManager.getTickerInfo()
              
    }

    @IBAction func StocksButtonPressed(_ sender: UIButton) {
    
        favouriteButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        stocksButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 28)
        stocksButton.setTitleColor(UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0), for: .normal)
        favouriteButton.setTitleColor(UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1.0), for: .normal)
        chosedStocksButton = true
        
        companies.removeAll()
        companyManager.getTickerInfo()
        
        tableView.reloadData()
        
    }
    
    @IBAction func FavouriteButtonPressed(_ sender: UIButton) {
        
        stocksButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        favouriteButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 28)
        favouriteButton.setTitleColor(UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0), for: .normal)
        stocksButton.setTitleColor(UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1.0), for: .normal)
        chosedStocksButton = false
        
        var companies1: [Company] = []
        
        for i in companies {
            
            for j in favourites {
                
                if i.ticker == j.ticker {
                    
                    companies1.append(i)
                    
                }
                    
            }
            
        }
        
        companies = companies1
        
        tableView.reloadData()
        
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
        
        var have = false
        for item in favourites {
            
            if item.ticker == companies[indexPath.row].ticker {
                
                have = true
                
            }
            
        }
        
        if have == true {
            
            cell.favouriteButton.setImage(UIImage(named: "Like"), for: .normal)
            
        } else {
            
            cell.favouriteButton.setImage(UIImage(named: "Hate"), for: .normal)
            
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
            
            // preparing to the next page
            
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
                
        var have = false
        var id = -1
        for i in 0..<favourites.count {
            
            if favourites[i].ticker == companies[tag].ticker {
                
                have = true
                id = i
                
            }
            
        }
        
        if have == true {
            
            context.delete(favourites[id])
            favourites.remove(at: id)
            
            if chosedStocksButton == false {
                
                companies.remove(at: tag)
                
            }
            
            
        } else {
            
            var newItem = Favourite(context: context)
            newItem.ticker = companies[tag].ticker
            
            favourites.append(newItem)
            
        }
              
        saveItems()
        tableView.reloadData()
        
    }
    
}

//MARK: - Model Manipulation Methods

extension ViewController {
    
    func loadItems() {
        
        let request: NSFetchRequest<Favourite> = Favourite.fetchRequest()
        
        do {
            
            favourites = try context.fetch(request)
            
        } catch {
            
            print("Error loading context \(error)")
            
        }
                
    }
    
    func saveItems() {
        
        do {
            
            try context.save()
            
        } catch {
            
            print("Error saving context \(error)")
            
        }
        
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
