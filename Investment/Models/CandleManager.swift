//
//  CandleManager.swift
//  Investment
//
//  Created by Yedige Ashirbek on 18.03.2023.
//

import Foundation

protocol CandleManagerDelegate {
    
    func didUpdateCandles(_ candleManager: CandleManager, candle: Candle)
    func candleManagerDidFailWithError(error: Error)
    
}

struct CandleManager {
    
    var delegate: CandleManagerDelegate?
    let baseURL = "https://finnhub.io/api/v1/stock/candle?symbol="
    var ticker = "AAPL"
    var resolution = "M"
    var to = Int(NSDate().timeIntervalSince1970)
    var from = 0
    
    mutating func getCandleInfo() {
        
        let url = "\(baseURL)\(ticker)&resolution=\(resolution)&from=\(from)&to=\(to)&token=\(Secret.token)"
        performRequest(with: url)
        
    }
    
    func performRequest(with urlString: String){
        
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                        
                    self.delegate?.candleManagerDidFailWithError(error: error!)
                    return
                    
                }
                if let safedata = data {
                    
                    if let candle = self.parseJson(safedata) {
                                                
                        self.delegate?.didUpdateCandles(self, candle: candle)
                        
                    }
                    
                }
                
            }
            
            task.resume()
            
        }
        
    }
    
    func parseJson (_ candleData: Data) -> Candle? {
        
        let decoder = JSONDecoder()
        
        do {
            
            let decodedData = try decoder.decode(CandleData.self, from: candleData)
            
            var prices = decodedData.c
            for i in 0..<prices.count {
                
                prices[i] = round(prices[i] * 100) / 100
                
            }
            let status = decodedData.s
            let timestamps = decodedData.t
            
            let candle = Candle(prices: prices, status: status, timestamps: timestamps)
            
            return candle
            
        } catch {
            
            delegate?.candleManagerDidFailWithError(error: error)
            return nil
            
        }
    }
    
}
