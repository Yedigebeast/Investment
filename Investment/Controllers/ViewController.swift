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
        
    private var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        return bar
    }()
    
    var searchbarHeight: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint()
        return constraint
    }()
    
    private var goBack: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "back"), for: .normal)
        button.tintColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.alignment = .bottom
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var constraint1: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint()
        return constraint
    }()
    
    private var constraint2: NSLayoutConstraint = {
        let constraint = NSLayoutConstraint()
        return constraint
    }()
    
    private var stocksButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Stocks", for: .normal)
        button.setTitleColor(UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 28)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var favouriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Favourite", for: .normal)
        button.setTitleColor(UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var popularRequestsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.text = "Popular Requests"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var popularRequestsCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.estimatedItemSize = CGSize(width: 1000, height: 40)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var previousSearchesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.text = "You've searched for this"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var showMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show More", for: .normal)
        button.setTitleColor(UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var previousSearchesCollectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.estimatedItemSize = CGSize(width: 1000, height: 40)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    var companyManager = CompanyManager()
    var priceManager = PriceManager()
    
    var companies: [Company] = []
    var baseCompanies: [Company] = []
    var favourites = [Favourite]()
    var previousSearches = [PreviousSearchResults]()
    var initialCompanies = [InitialCompanies]()
        
    var tappedCellIndex: Int = 0
    var chosedStocksButton = true
    var isGoBackButtonHidden = true
    var tickersOfCompanies: [String] = ["AAPL", "MSFT", "AMZN", "GOOGL", "TSLA", "NVDA", "BRK.A", "JPM", "JNJ", "V", "UNH", "HD", "PG", "BAC", "DIS"] // "PYPL", "MA", "NFLX", "ADBE", "CRM", "CMCSA", "XOM", "PFE", "CSCO", "TMO", "VZ", "INTC", "PEP", "KO", "ABT", "MRK", "ACN", "CVX", "AVGO", "COST", "WMT", "WFC", "ABBV", "NKE", "T", "DHR", "MCD", "LLY", "TXN", "MDT", "NEE", "LIN", "ORCL", "HON", "PM", "LOW", "INTU", "C", "MS", "QCOM", "UNP", "RTX", "SBUX"]
    var popularSearches: [String] = ["Apple", "Amazon", "Googl", "Tesla", "Microsoft", "Nvidia", "Visa", "Gamble"]
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
                
        searchBar.searchTextField.font = UIFont(name: "Montserrat-Semibold", size: 16)
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Find company or ticker", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        searchBar.layer.borderWidth = 1
        searchBar.clipsToBounds = true
        searchBar.layer.cornerRadius = searchBar.frame.height / 2
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextPositionAdjustment = UIOffset(horizontal: 13, vertical: 0)
        searchBar.setPositionAdjustment(UIOffset(horizontal: -10, vertical: 1), for: UISearchBar.Icon.clear)
        searchBar.setPositionAdjustment(UIOffset(horizontal: 10, vertical: 1), for: UISearchBar.Icon.search)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        stackView.addArrangedSubview(stocksButton)
        stackView.addArrangedSubview(favouriteButton)
        
        view.addSubview(searchBar)
        view.addSubview(goBack)
        view.addSubview(stackView)
        view.addSubview(popularRequestsLabel)
        view.addSubview(popularRequestsCollectionView)
        view.addSubview(previousSearchesLabel)
        view.addSubview(previousSearchesCollectionView)
        view.addSubview(showMoreButton)
        view.addSubview(tableView)
        
        searchbarHeight = NSLayoutConstraint(item: searchBar, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .height, multiplier: 1.0, constant: 56)
        constraint1 = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: view.layoutMarginsGuide, attribute: .top, multiplier: 1.0, constant: 76)
        constraint2 = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: stackView, attribute: .bottom, multiplier: 1.0, constant: 16)
        
        searchbarHeight.isActive = true
        constraint1.isActive = true
        constraint2.isActive = true
        
        NSLayoutConstraint.activate([
          
            searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            
            goBack.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 19),
            goBack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 36),
            
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            
            popularRequestsLabel.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            popularRequestsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),

            popularRequestsCollectionView.topAnchor.constraint(equalTo: popularRequestsLabel.bottomAnchor, constant: 11),
            popularRequestsCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            popularRequestsCollectionView.bottomAnchor.constraint(equalTo: previousSearchesLabel.topAnchor, constant: -28),
            popularRequestsCollectionView.heightAnchor.constraint(equalToConstant: 88),
            popularRequestsCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            previousSearchesLabel.bottomAnchor.constraint(equalTo: previousSearchesCollectionView.topAnchor, constant: -11),
            previousSearchesLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            
            previousSearchesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            previousSearchesCollectionView.heightAnchor.constraint(equalToConstant: 88),
            previousSearchesCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            showMoreButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 20),
            showMoreButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            showMoreButton.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -12),

            tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        
        goBack.addTarget(self, action: #selector(goBackButtonPressed), for: .touchUpInside)
        stocksButton.addTarget(self, action: #selector(StocksButtonPressed), for: .touchUpInside)
        favouriteButton.addTarget(self, action: #selector(FavouriteButtonPressed), for: .touchUpInside)
        showMoreButton.addTarget(self, action: #selector(showMoreButtonPressed), for: .touchUpInside)

        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        Constants.phoneViewWidth = view.frame.size.width
        
        searchBar.setImage(UIImage(named: "searchGlass"), for: .search, state: .normal)
        searchBar.setImage(UIImage(named: "cancel"), for: .clear, state: .normal)
        
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
        
        tableView.rowHeight = 99
        tableView.register(UINib(nibName: Constants.cellNibName, bundle: nil), forCellReuseIdentifier: Constants.cellIdentifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        
        loadItems()
        loadSearches()
        loadCompanies()
        
        initialCompanies = initialCompanies.sorted { (lhs, rhs) in
            return lhs.index < rhs.index
        }
        
        for i in 0..<initialCompanies.count {
                            
            var item = Company(ticker: "-", companyName: "-", imageLink: "-", currentPrice: "-", changePrice: "-", buyPrice: "-", img: UIImageView(frame: CGRect(x: 0, y: 0, width: 52, height: 52)))
                                        
            item.ticker = initialCompanies[i].ticker!
            item.companyName = initialCompanies[i].companyName!
            item.imageLink = initialCompanies[i].imageLink!
            item.currentPrice = initialCompanies[i].currentPrice!
            item.changePrice = initialCompanies[i].changePrice!
            item.buyPrice = initialCompanies[i].buyPrice!
            if initialCompanies[i].img != nil {
                item.img = UIImageView(image: UIImage(data: initialCompanies[i].img!))
            }
            
            companies.append(item)
            
        }
        baseCompanies = companies
        
        if companies.count == 0 {
            
            for ticker in tickersOfCompanies {
                
                companies.append(Company(ticker: ticker, companyName: "-", imageLink: "-", currentPrice: "-", changePrice: "-", buyPrice: "-", img: UIImageView(frame: CGRect(x: 0, y: 0, width: 52, height: 52))))
                
            }
            
        }
        
        for ticker in tickersOfCompanies {
            
            companyManager.tickerSelected = ticker
            companyManager.getTickerInfo()
            
            priceManager.tickerSelected = ticker
            priceManager.getPriceInfo()
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        saveItems()
        
    }
    
}

//MARK: - Buttons Pressed

extension ViewController {

    @objc func goBackButtonPressed(){
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
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
    
    @objc func showMoreButtonPressed() {
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
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
    
    @objc func StocksButtonPressed() {
    
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        favouriteButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 18)
        stocksButton.titleLabel?.font = UIFont(name: "Montserrat-Bold", size: 28)
        stocksButton.setTitleColor(UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0), for: .normal)
        favouriteButton.setTitleColor(UIColor(red: 0.73, green: 0.73, blue: 0.73, alpha: 1.0), for: .normal)
        chosedStocksButton = true
                
        companies.removeAll()
        
        companies = baseCompanies
        
        tableView.reloadData()
        
    }
    
    @objc func FavouriteButtonPressed() {
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
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
            
            if cell.companyImage.image?.jpegData(compressionQuality: 1.0) != nil {
                initialCompanies[indexPath.row].img = cell.companyImage.image?.jpegData(compressionQuality: 1.0)
                saveItems()
            }
            
            cell.selectedBackgroundView = {
               
                let selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
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
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        tappedCellIndex = indexPath.row
        let destinationVC = DetailsViewController()
        destinationVC.companyName = companies[tappedCellIndex].companyName
        destinationVC.ticker = companies[tappedCellIndex].ticker
        destinationVC.price = companies[tappedCellIndex].currentPrice
        destinationVC.changeInPrice = companies[tappedCellIndex].changePrice
        destinationVC.buyPrice = companies[tappedCellIndex].buyPrice
        destinationVC.delegate = self

        if companies[tappedCellIndex].changePrice.prefix(1) == "-" {

            destinationVC.colorOfChangeInPrice = UIColor(red: 0.7, green: 0.14, blue: 0.14, alpha: 1.0)

        } else {

            destinationVC.colorOfChangeInPrice = UIColor(red: 0.14, green: 0.7, blue: 0.36, alpha: 1.0)

        }

        var have: Bool = false
        for item in favourites {
            if item.ticker == companies[tappedCellIndex].ticker {
                have = true
            }
        }
        destinationVC.isTickerFavourite = have
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: false, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    
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
        
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
        
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {

        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        searchBar.text = ""
        searchBar.isHidden = false
        searchbarHeight.constant = 56
        searchBar.layer.cornerRadius = searchbarHeight.constant / 2
        searchBar.setImage(UIImage(named: "white"), for: .search, state: .normal)

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
                self.saveItems()
                                
            }
            
        }
        
    }
    
    func companyManagerDidFailWithError(error: Error) {
        
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
                    
                    var s = "\(price.currentPrice)"
                    s = s.addingSpaceInNumber()
                    
                    self.companies[i].currentPrice = "$\(s)"
                    
                    s = "\(price.buyPrice)"
                    s = s.addingSpaceInNumber()
                    
                    self.companies[i].buyPrice = "$\(s)"
                    
                    if price.change >= 0 {
                        
                        s = "\(price.change)"
                        s = s.addingSpaceInNumber()
                        var s1 = "\(price.percentChange)"
                        s1 = s1.addingSpaceInNumber()
                        self.companies[i].changePrice = "+$\(s) (\(s1)%)"
                        
                    } else {
                        
                        s = "\(-1 * price.change)"
                        s = s.addingSpaceInNumber()
                        var s1 = "\(-1 * price.percentChange)"
                        s1 = s1.addingSpaceInNumber()
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
                self.saveItems()
                                
            }
            
        }
        
    }
    
    func priceManagerDidFailWithError(error: Error) {
        
        print(error)
        
    }
    
}

//MARK: - SearchCell Delegate

extension ViewController: SearchCellDelegate {
    
    func searchCellPressed(tag: Int, viewTag: Int) {

        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
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
             
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
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

//MARK: - Details View Controller Delegate Methods

extension ViewController: DetailsViewControllerDelegate {
   
    func didUpdateFavouriteButton(isTickerFavourite: Bool, ticker: String) {
        
        var have = false
        var id = -1
        for i in 0..<favourites.count {
            
            if favourites[i].ticker == ticker {
                
                have = true
                id = i
                
            }
            
        }
        
        if have == true {
            
            if isTickerFavourite == false {
                
                context.delete(favourites[id])
                favourites.remove(at: id)
                
            }
            
            
        } else {
            
            if isTickerFavourite == true {
                
                let newItem = Favourite(context: context)
                newItem.ticker = ticker
                
                favourites.append(newItem)
                
            }
            
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
    
    func loadSearches() {
        
        let request: NSFetchRequest<PreviousSearchResults> = PreviousSearchResults.fetchRequest()
        
        do {
            
            previousSearches = try context.fetch(request)
            
        } catch {
            
            print("Error loading context \(error)")
            
        }
        
    }
    
    func loadCompanies() {
        
        let request: NSFetchRequest<InitialCompanies> = InitialCompanies.fetchRequest()
        
        do {
            
            initialCompanies = try context.fetch(request)
            
        } catch {
            
            print("Error loading companies \(error)")
            
        }
        
    }
    
    func saveItems() {
        
        for _ in 0..<initialCompanies.count {
                    
            context.delete(initialCompanies[0])
            initialCompanies.remove(at: 0)
            
        }
        
        for i in 0..<baseCompanies.count {
            
            //print(baseCompanies[i].ticker)
            let item = InitialCompanies(context: context)
            item.index = Int16(i)
            item.ticker = baseCompanies[i].ticker
            item.companyName = baseCompanies[i].companyName
            item.imageLink = baseCompanies[i].imageLink
            item.currentPrice = baseCompanies[i].currentPrice
            item.changePrice = baseCompanies[i].changePrice
            item.buyPrice = baseCompanies[i].buyPrice
            item.img = baseCompanies[i].img.image?.jpegData(compressionQuality: 1.0)
            initialCompanies.append(item)
            
        }
        
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

//MARK: - Get String width

extension String {
    
    func getStringwidth(height: CGFloat, font: UIFont) -> CGFloat {
        
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.width
        
    }
    
}

//MARK: - Adding Space in Number

extension String {
    
    func addingSpaceInNumber () -> String {
        
        var cntr: Int = 0
        var saw: Bool = false
        var p = self
        
        for i in stride(from: self.count - 1, through: 0, by: -1) {
            
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
    
}
