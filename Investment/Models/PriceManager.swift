//
//  PriceManager.swift
//  Investment
//
//  Created by Yedige Ashirbek on 02.03.2023.
//

import Foundation

protocol PriceManagerDelegate {
    
    func didUpdatePrice(_ priceManager: PriceManager, price: Price, ticker: String)
    func functionPriceManagerDidFailWithError(error: Error)
    
}

struct PriceManager {
    
    var delegate: PriceManagerDelegate?
    let baseURL = "https://finnhub.io/api/v1/quote?symbol="
    var tickerSelected = "AAPL"
    
    func getPriceInfo() {
        
        let url = "\(baseURL)\(tickerSelected)&token=\(Secret.token)"
        performRequest(with: url)
        
    }
    
    func performRequest(with urlString: String){
        
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                        
                    self.delegate?.functionPriceManagerDidFailWithError(error: error!)
                    return
                    
                }
                if let safedata = data {
                    
                    if let price = self.parseJson(safedata) {
                                                
                        self.delegate?.didUpdatePrice(self, price: price, ticker: tickerSelected)
                        
                    }
                    
                }
                
            }
            
            task.resume()
            
        }
        
    }
    
    func parseJson (_ priceData: Data) -> Price? {
        
        let decoder = JSONDecoder()
        
        do {
            
            let decodedData = try decoder.decode(PriceData.self, from: priceData)
            let currentPrice = round(decodedData.c * 100) / 100
            let change = round(decodedData.d * 100) / 100
            let percentChange = round(decodedData.dp * 100) / 100
            
            let price = Price(currentPrice: "\(currentPrice)", change: change, percentChange: percentChange)
            
            return price
            
        } catch {
            
            delegate?.functionPriceManagerDidFailWithError(error: error)
            return nil
            
        }
    }
    
}
