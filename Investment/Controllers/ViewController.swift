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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var stocksButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var popularRequestsLabel: UILabel!
    @IBOutlet weak var popularRequestsCollectionView: UICollectionView!
    @IBOutlet weak var previousSearchesLabel: UILabel!
    @IBOutlet weak var previousSearchesCollectionView: UICollectionView!
    
    var companyManager = CompanyManager()
    var priceManager = PriceManager()
    
    var companies: [Company] = []
    var baseCompanies: [Company] = []
    var favourites = [Favourite]()
    var chosedStocksButton = true
    var searchButtonWasClicked = false
    
    var tickersOfCompanies: [String] = ["AAPL", "MSFT", "AMZN", "GOOGL", "TSLA", "NVDA", "BRK.A", "JPM", "JNJ", "V", "UNH", "HD", "PG", "BAC", "DIS"] // "PYPL", "MA", "NFLX", "ADBE", "CRM", "CMCSA", "XOM", "PFE", "CSCO", "TMO", "VZ", "INTC", "PEP", "KO", "ABT", "MRK", "ACN", "CVX", "AVGO", "COST", "WMT", "WFC", "ABBV", "NKE", "T", "DHR", "MCD", "LLY", "TXN", "MDT", "NEE", "LIN", "ORCL", "HON", "PM", "LOW", "INTU", "C", "MS", "QCOM", "UNP", "RTX", "SBUX"]
        
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        popularRequestsLabel.isHidden = true
        popularRequestsCollectionView.isHidden = true
        previousSearchesLabel.isHidden = true
        previousSearchesCollectionView.isHidden = true
        
        popularRequestsCollectionView.register(UINib(nibName: Constants.collectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Constants.collectionViewCellIdentifier)
        previousSearchesCollectionView.register(UINib(nibName: Constants.collectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Constants.collectionViewCellIdentifier)
        popularRequestsCollectionView.showsVerticalScrollIndicator = false
        popularRequestsCollectionView.showsHorizontalScrollIndicator = false
        previousSearchesCollectionView.showsVerticalScrollIndicator = false
        previousSearchesCollectionView.showsHorizontalScrollIndicator = false
        popularRequestsCollectionView.delegate = self
        previousSearchesCollectionView.delegate = self
        popularRequestsCollectionView.dataSource = self
        previousSearchesCollectionView.dataSource = self
        
        companyManager.delegate = self
        priceManager.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        tableView.rowHeight = 68
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        loadItems()
        
        for ticker in tickersOfCompanies {
            
            companies.append(Company(ticker: ticker, companyName: "-", imageLink: "-", currentPrice: "-", changePrice: "-"))
            
        }
        
        for ticker in tickersOfCompanies {
            
            companyManager.tickerSelected = ticker
            companyManager.getTickerInfo()
            
            priceManager.tickerSelected = ticker
            priceManager.getPriceInfo()
            
        }
        
    }
}

//MARK: - Buttons Pressed

extension ViewController {

    @IBAction func StocksButtonPressed(_ sender: UIButton) {
    
        favouriteButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        stocksButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 28)
        stocksButton.setTitleColor(UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0), for: .normal)
        favouriteButton.setTitleColor(UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1.0), for: .normal)
        chosedStocksButton = true
                
        companies.removeAll()
        
        companies = baseCompanies
        
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
        
        if (companies[indexPath.row].companyName != "-" && companies[indexPath.row].currentPrice != "-"){
            
            cell.delegate = self
            cell.favouriteButton.tag = indexPath.row
            cell.layer.cornerRadius = 16
            
            cell.companyName.text = companies[indexPath.row].companyName
            cell.label.text = companies[indexPath.row].ticker
            cell.cost.text = companies[indexPath.row].currentPrice
            cell.changes.text = companies[indexPath.row].changePrice
                           
            if companies[indexPath.row].changePrice.prefix(1) == "-" {
                
                cell.changes.textColor = UIColor(red: 0.7, green: 0.14, blue: 0.14, alpha: 1.0)
                
            } else {
                
                cell.changes.textColor = UIColor(red: 0.14, green: 0.7, blue: 0.36, alpha: 1.0)
                
            }
            
            var have: Bool = false
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

//MARK: - CollectionView DataSource Methods

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return tickersOfCompanies.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = popularRequestsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCellIdentifier, for: indexPath) as! SearchCell
        
        cell.cellLabel.setTitle(tickersOfCompanies[indexPath.row], for: .normal)
        cell.layer.cornerRadius = 25
        cell.frame.size.height = 40
        
        return cell
        
    }
    
}

//MARK: - Collection View Delegate Flow Layout Methods

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 4
        
    }
    
}

//MARK: - CollectionView Delegate Methods

extension ViewController: UICollectionViewDelegate {
    
    
    
}

//MARK: - UISearchbar Delegate Methods

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //print(baseCompanies)
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        companies = baseCompanies
        searchButtonWasClicked = true
        
        if (searchBar.text != ""){
            
            companies = companies.filter{
                
                $0.ticker.lowercased().contains(searchBar.text!.lowercased()) ||
                $0.companyName.lowercased().contains(searchBar.text!.lowercased())
                
            }
            //print(companies)
            
        }
        
        tableView.reloadData()
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        searchBar.text = ""
        
        tableView.isHidden = true
        stocksButton.isHidden = true
        favouriteButton.isHidden = true
        
        popularRequestsLabel.isHidden = false
        popularRequestsCollectionView.isHidden = false
        previousSearchesLabel.isHidden = false
        previousSearchesCollectionView.isHidden = false
        return true
        
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
        if searchButtonWasClicked == false{
            
            companies = baseCompanies
            
        }
        searchButtonWasClicked = false
        tableView.isHidden = false
        stocksButton.isHidden = false
        favouriteButton.isHidden = false
        
        popularRequestsLabel.isHidden = true
        popularRequestsCollectionView.isHidden = true
        previousSearchesLabel.isHidden = true
        previousSearchesCollectionView.isHidden = true
        
        tableView.reloadData()

        return true
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
}

//MARK: - CompanyManager Delegate Methods

extension ViewController: CompanyManagerDelegate {
    
    func didUpdateCompany(_ companyManager: CompanyManager, company: Company) {
        
        DispatchQueue.main.async {
            
            var canReload: Bool = true
            
            for i in 0..<self.companies.count {
            
                if (self.companies[i].ticker == company.ticker) {
                    
                    self.companies[i].companyName = company.companyName
                    self.companies[i].imageLink = company.imageLink
                    
                }
                
                if (self.companies[i].companyName == "-" || self.companies[i].currentPrice == "-"){
                    
                    canReload = false
                    
                }
                
            }
            
            if canReload == true {
                
                self.baseCompanies = self.companies
                self.tableView.reloadData()
                
            }
            
        }
        
    }
    
    func didFailWithError(error: Error) {
        
        print(error)
        
    }
    
}

//MARK: - PriceManager Delegate Methods

extension ViewController: PriceManagerDelegate {
    
    func didUpdatePrice(_ priceManager: PriceManager, price: Price, ticker: String) {
        
        DispatchQueue.main.async {
                        
            var canReload: Bool = true
            
            for i in 0..<self.companies.count {
            
                if (self.companies[i].ticker == ticker) {
                    
                    var s = addingSpaceInNumber(price: "\(price.currentPrice)")
                    
                    self.companies[i].currentPrice = "$\(s)"
                    
                    if price.change >= 0 {
                        
                        s = addingSpaceInNumber(price: "\(price.change)")
                        let s1 = addingSpaceInNumber(price: "\(price.percentChange)")
                        self.companies[i].changePrice = "+$\(s) (\(s1)%)"
                        
                    } else {
                        
                        s = addingSpaceInNumber(price: "\(-1 * price.change)")
                        let s1 = addingSpaceInNumber(price: "\(-1 * price.percentChange)")
                        self.companies[i].changePrice = "-$\(s) (\(s1)%)"

                    }
                    
                }
                
                if (self.companies[i].companyName == "-" || self.companies[i].currentPrice == "-"){
                    
                    canReload = false
                    
                }
                
            }

            if canReload == true {
                
                self.baseCompanies = self.companies
                self.tableView.reloadData()
                
            }
            
        }
        
    }
    
    func functionPriceManagerDidFailWithError(error: Error) {
        
        print(error)
        
    }
    
}

func addingSpaceInNumber (price: String) -> String {
    
    var cntr: Int = 0
    var saw: Bool = false
    var p = price
    
    for i in stride(from: price.count - 1, through: 0, by: -1) {
        
        if p.characterAtIndex(index: i) == "." {
            
            saw = true
            
        }
        
        if let character = p.characterAtIndex(index: i){
            
            if "0" <= character && character <= "9" {
                
                if saw == true {
                    cntr += 1
                }
                
            }
            
        }
        
        if cntr == 3 && i != 0 {
            
            p.insert(" ", at: p.index(p.startIndex, offsetBy: i))
            cntr = 0
            
        }

    }
    
    if p.suffix(2) == ".0" {
        
        p = String(p.dropLast())
        p = String(p.dropLast())
        
    }
    
    return p
    
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
            
            let newItem = Favourite(context: context)
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

//MARK: - Get the symbol at index in string

extension String {
    
    func characterAtIndex(index: Int) -> Character? {
        
        var cur = 0
        for char in self {
            
            if cur == index {
                
                return char
                
            }
            
            cur += 1
            
        }
        
        return nil
    }
    
}
