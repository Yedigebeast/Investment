//
//  DetailsViewController.swift
//  Investment
//
//  Created by Yedige Ashirbek on 26.02.2023.
//

import UIKit
import Charts
import ChameleonFramework

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
    @IBOutlet weak var viewInOrderOfChart: UIView!
    @IBOutlet weak var chipsCollectionView: UICollectionView!
    @IBOutlet weak var buyButton: UIButton!
    
    var delegate: DetailsViewControllerDelegate?
    var companyName: String = ""
    var ticker: String = ""
    var price: String = ""
    var changeInPrice: String = ""
    var colorOfChangeInPrice: UIColor = .black
    var buyPrice: String = ""
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
    
    var lineChart = LineChartView()
    let customMarker = LineChartCustomMarker()
    
    var candleManager = CandleManager()
    var candles: Candle = Candle(prices: [], status: "ok", timestamps: [])
    
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
        collectionView.tag = 0
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        separatorLine.dropShadow(alpha: 0.05, offsetWidth: 0, offsetHeight: 2, radius: 2)
        separatorLine.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        priceLabel.text = price
        changeInPriceLabel.text = changeInPrice
        changeInPriceLabel.textColor = colorOfChangeInPrice
        
        lineChart.delegate = self
        lineChart.frame = viewInOrderOfChart.frame
        customMarker.chartView = lineChart
        lineChart.marker = customMarker
        
        lineChart.doubleTapToZoomEnabled = false
        
        lineChart.minOffset = 0
        lineChart.rightAxis.enabled = false
        lineChart.leftAxis.enabled = false
        lineChart.xAxis.enabled = false
        lineChart.legend.enabled = false
    
        view.addSubview(lineChart)
        
        candleManager.delegate = self
        setData(button: "All")
        
        chipsCollectionView.delegate = self
        chipsCollectionView.dataSource = self
        chipsCollectionView.register(UINib(nibName: Constants.chipsCellNibName, bundle: nil), forCellWithReuseIdentifier: Constants.chipsCellIdentifier)
        chipsCollectionView.tag = 1
        
        buyButton.layer.cornerRadius = 16
        buyButton.setTitle(buyPrice, for: .normal)
        
    }
    
//MARK: - Button Pressed
    
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

//MARK: - Candle Manager Delegate Methods

extension DetailsViewController: CandleManagerDelegate {
    
    func didUpdateCandles(_ candleManager: CandleManager, candle: Candle) {
        
        DispatchQueue.main.async {
            
            self.candles = candle

            var entries = [ChartDataEntry]()
            
            for x in 0..<self.candles.prices.count {
                
                entries.append(ChartDataEntry(x: Double(self.candles.timestamps[x]), y: self.candles.prices[x]))
                
            }
            
            let set = LineChartDataSet(entries: entries)
            set.drawCirclesEnabled = false
            set.mode = .horizontalBezier
            set.lineWidth = 2
            set.setColor(.black)
            set.setDrawHighlightIndicators(false)
            
            let colors = [HexColor("#000000", 1.0)!, HexColor("#FFFFFF", 0.0)!]
            set.fillColor = NSUIColor(cgColor: GradientColor(.topToBottom, frame: self.lineChart.frame, colors: colors).cgColor)
            set.drawFilledEnabled = true
            
            let data = LineChartData(dataSet: set)
            data.setDrawValues(false)
            
            self.lineChart.data = data
            self.lineChart.animate(xAxisDuration: 2.0)
            
        }
        
    }
    
    func candleManagerDidFailWithError(error: Error) {
    
        print(error)
        
    }
    
}

//MARK: - Line Chart Delegate Methods
extension DetailsViewController: ChartViewDelegate {
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        lineChart.marker = customMarker
        
        let selectedXValue = NSDate(timeIntervalSince1970: (entry.x + 6 * 60 * 60))

        var selectedYValue = "\(entry.y)"
        selectedYValue = selectedYValue.addingSpaceInNumber()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = "dd MMM yyyy"
        
        customMarker.price.text = "$\(selectedYValue)"
        customMarker.date.text = dateFormatter.string(from: selectedXValue as Date).lowercased()

        //print(entry.x, " ", selectedXValue, " ", selectedYValue)
        
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
        lineChart.marker = nil
        setData(button: chipsViewButtons[tag].text)
    }


}

//MARK: - Drop Shadow Effect

extension UIView {
    
    func dropShadow(scale: Bool = true, alpha: Double, offsetWidth: Int, offsetHeight: Int, radius: Double) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha).cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: offsetWidth, height: offsetHeight)
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
      }
    
}

//MARK: - Get Candle Information According to the Button selected

extension DetailsViewController {
    
    func setData(button: String) {
        
        candleManager.ticker = ticker
        candleManager.to = Int(NSDate().timeIntervalSince1970)
        if button == "D" {
            
            candleManager.from = candleManager.to - (24 * 60 * 60)
            candleManager.resolution = "30"
//            print("selected the chart to look for a day")
            
        } else if button == "W" {
            
            candleManager.from = candleManager.to - (7 * 24 * 60 * 60)
            candleManager.resolution = "60"
//            print("selected the chart to look for a week")
            
        } else if button == "M" {
            
            candleManager.from = candleManager.to - (30 * 24 * 60 * 60)
            candleManager.resolution = "D"
//            print("selected the chart to look for a month")
            
        } else if button == "6M" {
            
            candleManager.from = candleManager.to - (6 * 30 * 24 * 60 * 60)
            candleManager.resolution = "W"
//            print("selected the chart to look for 6 months")
            
        } else if button == "1Y" {
         
            candleManager.from = candleManager.to - (12 * 30 * 24 * 60 * 60)
            candleManager.resolution = "W"
//            print("selected the chart to look for a year")
            
        }else if button == "All" {
            
            candleManager.from = 0
            candleManager.resolution = "M"
//            print("selected the chart to look for all history")
            
        }
        
        candleManager.getCandleInfo()
        
    }
    
}
