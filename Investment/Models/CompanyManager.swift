//
//  CompanyManager.swift
//  Investment
//
//  Created by Yedige Ashirbek on 25.02.2023.
//

import UIKit

protocol CompanyManagerDelegate {
    
    func didUpdateCompany(_ companyManager: CompanyManager, company: Company)
    func didFailWithError(error: Error)
    
}

struct CompanyManager {
    
    var delegate: CompanyManagerDelegate?
    let baseURL = "https://finnhub.io/api/v1/stock/profile2?symbol="
    var tickersOfCompanies: [String] = ["YNDX", "AAPL", "MSFT", "AMZN", "GOOGL", "TSLA", "NVDA", "BRK.B", "JPM", "JNJ", "V", "UNH", "HD", "PG", "BAC", "DIS", "PYPL", "MA", "NFLX", "ADBE", "CRM", "CMCSA"] // "XOM", "PFE", "CSCO", "TMO", "VZ", "INTC", "PEP", "KO", "ABT", "MRK", "ACN", "CVX", "AVGO", "COST", "WMT", "WFC", "ABBV", "NKE", "T", "DHR", "MCD", "LLY", "TXN", "MDT", "NEE", "LIN", "ORCL", "HON", "PM", "LOW", "INTU", "C", "MS", "QCOM", "UNP", "RTX", "SBUX"]
    var tickerSelected = "AAPL"
    
    func getTickerInfo (){
        
        let url = "\(baseURL)\(tickerSelected)&token=\(Secret.token)"
        performRequest(with: url)
    }
    
    func performRequest (with urlString: String){
        
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                        
                    self.delegate?.didFailWithError(error: error!)
                    return
                    
                }
                if let safedata = data {
                    
                    if let company = self.parseJson(safedata) {
                                                
                        self.delegate?.didUpdateCompany(self, company: company)
                        
                    }
                    
                }
                
            }
            
            task.resume()
            
        }
        
    }
    
    func parseJson (_ companyData: Data) -> Company? {
        
        let decoder = JSONDecoder()
        
        do {
            
            let decodedData = try decoder.decode(CompanyData.self, from: companyData)
            let companyName = decodedData.name
            let ticker = decodedData.ticker
            let imageLink = decodedData.logo
            
            let company = Company(ticker: ticker, companyName: companyName, imageLink: imageLink)
            
            return company
            
        } catch {
            
            delegate?.didFailWithError(error: error)
            return nil
            
        }
    }
    
}
