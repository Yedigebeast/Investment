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
    @IBOutlet weak var showMoreButton: UIButton!
    @IBOutlet weak var goBack: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var popularRequestsLabel: UILabel!
    @IBOutlet weak var popularRequestsCollectionView: UICollectionView!
    @IBOutlet weak var previousSearchesLabel: UILabel!
    @IBOutlet weak var previousSearchesCollectionView: UICollectionView!
           
    @IBOutlet weak var constraint1: NSLayoutConstraint!
    @IBOutlet weak var constraint2: NSLayoutConstraint!
    @IBOutlet weak var searchbarHeight: NSLayoutConstraint!
    

    var companyManager = CompanyManager()
    var priceManager = PriceManager()
    
    var companies: [Company] = []
    var baseCompanies: [Company] = []
    var favourites = [Favourite]()
    var previousSearches = [PreviousSearchResults]()
        
    var chosedStocksButton = true
    var isGoBackButtonHidden = true
    var tickersOfCompanies: [String] = ["AAPL", "MSFT", "AMZN", "GOOGL", "TSLA", "NVDA", "BRK.A", "JPM", "JNJ", "V", "UNH", "HD", "PG", "BAC", "DIS"] // "PYPL", "MA", "NFLX", "ADBE", "CRM", "CMCSA", "XOM", "PFE", "CSCO", "TMO", "VZ", "INTC", "PEP", "KO", "ABT", "MRK", "ACN", "CVX", "AVGO", "COST", "WMT", "WFC", "ABBV", "NKE", "T", "DHR", "MCD", "LLY", "TXN", "MDT", "NEE", "LIN", "ORCL", "HON", "PM", "LOW", "INTU", "C", "MS", "QCOM", "UNP", "RTX", "SBUX"]
    var popularSearches: [String] = ["Apple", "Amazon", "Googl", "Tesla", "Microsoft", "Nvidia", "Visa", "Gamble"]
    
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
       
        searchBar.searchTextField.font = UIFont(name: "Montserrat-Semibold", size: 16)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Find company or ticker", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        searchBar.setImage(UIImage(named: "searchGlass"), for: UISearchBar.Icon.search, state: .normal)
        searchBar.setImage(UIImage(named: "cancel"), for: UISearchBar.Icon.clear, state: .normal)
        searchBar.layer.borderWidth = 1
        searchBar.clipsToBounds = true
        searchBar.layer.cornerRadius = searchBar.frame.height / 2
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 13, vertical: 0)
        searchBar.setPositionAdjustment(UIOffset(horizontal: -10, vertical: 1), for: UISearchBar.Icon.clear)
        searchBar.setPositionAdjustment(UIOffset(horizontal: 10, vertical: 1), for: UISearchBar.Icon.search)
        
        popularRequestsLabel.isHidden = true
        popularRequestsCollectionView.isHidden = true
        previousSearchesLabel.isHidden = true
        previousSearchesCollectionView.isHidden = true
        showMoreButton.isHidden = true
        goBack.isHidden = true
        
        popularRequestsCollectionView.register(UINib(nibName: Constants.collectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Constants.collectionViewCellIdentifier)
        previousSearchesCollectionView.register(UINib(nibName: Constants.collectionViewCellNibName, bundle: nil), forCellWithReuseIdentifier: Constants.collectionViewCellIdentifier)
        popularRequestsCollectionView.tag = 1
        previousSearchesCollectionView.tag = 2
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
        
        tableView.rowHeight = 76
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        loadItems()
        loadSearches()
        
        for ticker in tickersOfCompanies {
            
            companies.append(Company(ticker: ticker, companyName: "-", imageLink: "-", currentPrice: "-", changePrice: "-", img: UIImageView(frame: CGRect(x: 0, y: 0, width: 52, height: 52))))
            
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

    @IBAction func goBackButtonPressed(_ sender: UIButton){
        
        DispatchQueue.main.async {
            self.searchBar.resignFirstResponder()
        }
        
        searchBar.text = ""
        stocksButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 28)
        stocksButton.isUserInteractionEnabled = true
        
        favouriteButton.isHidden = false
        stocksButton.isHidden = false
        tableView.isHidden = false
        popularRequestsLabel.isHidden = true
        previousSearchesLabel.isHidden = true
        popularRequestsCollectionView.isHidden = true
        previousSearchesCollectionView.isHidden = true
        showMoreButton.isHidden = true
        goBack.isHidden = true
        isGoBackButtonHidden = true
        
        searchBar.setImage(UIImage(named: "searchGlass"), for: UISearchBar.Icon.search, state: .normal)
        
        companies = baseCompanies
        tableView.reloadData()
        
    }
    
    @IBAction func showMoreButtonPressed(_ sender: UIButton) {
        
        DispatchQueue.main.async {
            self.searchBar.resignFirstResponder()
        }
        
        searchBar.text = ""
        stocksButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 28)
        stocksButton.isUserInteractionEnabled = true
        
        favouriteButton.isHidden = false
        showMoreButton.isHidden = true
        goBack.isHidden = true
        isGoBackButtonHidden = true
        
        searchBar.setImage(UIImage(named: "searchGlass"), for: UISearchBar.Icon.search, state: .normal)
        
        companies = baseCompanies
        tableView.reloadData()
        
    }
    
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
            cell.frame.size.width = view.frame.size.width - 32
            
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
                
                if companies[indexPath.row].img.image == nil {
                    
                    companies[indexPath.row].img.downloadedsvg(from: url)
                    
                }
                
                cell.companyImage.image = companies[indexPath.row].img.image
                
                if cell.companyImage.image == nil {
                    
                    cell.companyImage.downloadedsvg(from: url)
                    
                }
                                
            } else {
                
                cell.companyImage.kf.setImage(with: url)
                
            }
            
            cell.selectedBackgroundView = {
               
                let selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: 68))
                selectedBackgroundView.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
                selectedBackgroundView.layer.cornerRadius = 16
                return selectedBackgroundView
                
            }()
            
            let maskLayer = CALayer()
            maskLayer.cornerRadius = 16
            maskLayer.backgroundColor = cell.backgroundColor?.cgColor
            maskLayer.frame = CGRect(x: cell.bounds.origin.x, y: cell.bounds.origin.y, width: cell.bounds.width, height: cell.bounds.height).insetBy(dx: 0, dy: 4)
            cell.layer.mask = maskLayer
            
        }
        
        return cell
        
    }
    
}

//MARK: - TableView Delegate Methods

extension ViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        if (scrollView.contentOffset.y <= 0){
            
            searchBar.isHidden = false
            goBack.isHidden = isGoBackButtonHidden
            searchbarHeight.constant = 56

            constraint1.constant = 76
            constraint2.constant = 16
            
        } else if (0 <= scrollView.contentOffset.y && scrollView.contentOffset.y <= 56.0){
            
            searchBar.isHidden = false
            goBack.isHidden = true
            searchbarHeight.constant = 56 - scrollView.contentOffset.y

            constraint1.constant = searchbarHeight.constant + 20
            constraint2.constant = 16
            
        } else if (scrollView.contentOffset.y > 56.0) {
            
            searchBar.isHidden = true
            goBack.isHidden = true
            searchbarHeight.constant = 0
            
            constraint1.constant = 12
            constraint2.constant = 12

        }
        
        searchBar.layer.cornerRadius = searchbarHeight.constant / 2
        
//        print("scrolls table view \(scrollView.contentOffset.y), the distance between safearea.top and tableview.top is \(constraint1.constant)")
        
    }
    
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
        
        if collectionView.tag == 1 {
            
            return popularSearches.count
            
        } else {
            
            return previousSearches.count
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //print("cellForItemAt: ", collectionView.tag, " ", indexPath.row)
        
        let cell = popularRequestsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.collectionViewCellIdentifier, for: indexPath) as! SearchCell
                
        cell.delegate = self
        cell.collectionViewTag = collectionView.tag
        cell.layer.cornerRadius = 20
        
        if collectionView.tag == 1 {
            
            cell.button.tag = indexPath.row
            cell.cellLabel.text = (popularSearches[indexPath.row])
            
        } else {
            
            for i in 0..<previousSearches.count {
                
                if previousSearches[i].index == previousSearches.count - indexPath.row - 1 {
                    
                    cell.cellLabel.text = previousSearches[i].search
                    cell.button.tag = i
                    
                }
                
            }

        }

        return cell
        
    }
    
}

//MARK: - Collection View Delegate Flow Layout Methods

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 8

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 4

    }
    
}

//MARK: - UISearchbar Delegate Methods

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {

        searchBar.text = ""
        searchBar.isHidden = false
        searchbarHeight.constant = 56
        searchBar.layer.cornerRadius = searchbarHeight.constant / 2

        constraint1.constant = 76
        constraint2.constant = 16
        
        let index = tableView.indexPathForRow(at: CGPoint(x: 0, y: 0))
        tableView.scrollToRow(at: index!, at: .top, animated: true)
                
        companies = baseCompanies

        favouriteButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        stocksButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        stocksButton.setTitleColor(UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0), for: .normal)
        favouriteButton.setTitleColor(UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1.0), for: .normal)
        chosedStocksButton = true
        stocksButton.isUserInteractionEnabled = false

        tableView.isHidden = true
        stocksButton.isHidden = true
        favouriteButton.isHidden = true
        showMoreButton.isHidden = true
        
        popularRequestsLabel.isHidden = false
        popularRequestsCollectionView.isHidden = false
        previousSearchesLabel.isHidden = false
        previousSearchesCollectionView.isHidden = false
        goBack.isHidden = false
        isGoBackButtonHidden = false
        
        searchBar.setImage(UIImage(named: "white"), for: UISearchBar.Icon.search, state: .normal)
        
        return true

    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        
        if (searchBar.text != ""){
            
            var have = -1
            for i in 0..<previousSearches.count {
                
                if previousSearches[i].search!.lowercased() == searchBar.text!.lowercased() {
                    
                    have = i
                    
                }
                
            }
            
            if (have == -1){
                
                let newSearchResult = PreviousSearchResults(context: context)
                newSearchResult.search = searchBar.text!
                var mx: Int = -1
                for i in previousSearches {
                    
                    mx = max(mx, Int(i.index))
                    
                }
                newSearchResult.index = Int16(mx + 1)
                previousSearches.append(newSearchResult)
                
                if previousSearches.count == 11 {
                    
                    var id = 0
                    for i in 0..<previousSearches.count {
                        
                        if previousSearches[i].index == 0 {
                            
                            id = i
                            
                        }
                        
                    }
                    
                    context.delete(previousSearches[id])
                    previousSearches.remove(at: id)
                    
                    for i in 0..<previousSearches.count {
                        
                        previousSearches[i].index = previousSearches[i].index - 1
                        
                    }
                    
                }
                
            } else if have != -1 {
                
                for i in 0..<previousSearches.count {
                    
                    if previousSearches[i].index > previousSearches[have].index {
                        
                        previousSearches[i].index = previousSearches[i].index - 1
                        
                    }
                    
                }
                
                previousSearches[have].index = Int16(previousSearches.count - 1)
                
            }
            
            saveItems()
            previousSearchesCollectionView.reloadData()
            
        }
        
        return true
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            
        if (searchBar.text != ""){
            
            companies = baseCompanies
            
            companies = companies.filter{
                
                $0.ticker.lowercased().contains(searchBar.text!.lowercased()) ||
                $0.companyName.lowercased().contains(searchBar.text!.lowercased())
                
            }
            
            tableView.isHidden = false
            stocksButton.isHidden = false
            favouriteButton.isHidden = true
            showMoreButton.isHidden = false
            
            popularRequestsLabel.isHidden = true
            popularRequestsCollectionView.isHidden = true
            previousSearchesLabel.isHidden = true
            previousSearchesCollectionView.isHidden = true
            
        } else if searchBar.text == "" {
            
            tableView.isHidden = true
            stocksButton.isHidden = true
            favouriteButton.isHidden = true
            showMoreButton.isHidden = true
            
            popularRequestsLabel.isHidden = false
            popularRequestsCollectionView.isHidden = false
            previousSearchesLabel.isHidden = false
            previousSearchesCollectionView.isHidden = false
            
        }
        
        tableView.reloadData()
        
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

//MARK: - SearchCell Delegate

extension ViewController: SearchCellDelegate {
    
    func searchCellPressed(tag: Int, viewTag: Int) {

        if viewTag == 1 {
            
            searchBar.text = popularSearches[tag]
            
        } else {
            
            searchBar.text = previousSearches[tag].search
            
        }
        
        companies = baseCompanies
        
        companies = companies.filter{
            
            $0.ticker.lowercased().contains(searchBar.text!.lowercased()) ||
            $0.companyName.lowercased().contains(searchBar.text!.lowercased())
            
        }
        
        tableView.isHidden = false
        stocksButton.isHidden = false
        favouriteButton.isHidden = true
        showMoreButton.isHidden = false
        
        popularRequestsLabel.isHidden = true
        popularRequestsCollectionView.isHidden = true
        previousSearchesLabel.isHidden = true
        previousSearchesCollectionView.isHidden = true
        
        tableView.reloadData()
        
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
    
    func loadSearches() {
        
        let request: NSFetchRequest<PreviousSearchResults> = PreviousSearchResults.fetchRequest()
        
        do {
            
            previousSearches = try context.fetch(request)
            
        } catch {
            
            print("Error loading context \(error)")
            
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

//MARK: - Get String width

extension String {
    
    func getStringwidth(height: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.width
        
    }
    
}
