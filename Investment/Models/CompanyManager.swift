//
//  CompanyManager.swift
//  Investment
//
//  Created by Yedige Ashirbek on 25.02.2023.
//

import Foundation
import UIKit

protocol CompanyManagerDelegate {
    
    func didUpdateCompany(_ companyManager: CompanyManager, company: Company)
    func companyManagerDidFailWithError(error: Error)
    
}

struct CompanyManager {
    
    var delegate: CompanyManagerDelegate?
    let baseURL = "https://finnhub.io/api/v1/stock/profile2?symbol="
    var tickerSelected = "AAPL"
    
    mutating func getTickerInfo (){
        
        let url = "\(baseURL)\(tickerSelected)&token=\(Secret.token)"
        performRequest(with: url)
        
    }
    
    func performRequest (with urlString: String){
        
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                
                if error != nil {
                        
                    self.delegate?.companyManagerDidFailWithError(error: error!)
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
            
            let company = Company(ticker: ticker, companyName: companyName, imageLink: imageLink, currentPrice: "$100", changePrice: "+0,5%", buyPrice: "$110", img: UIImageView(frame: CGRect(x: 0, y: 0, width: 52, height: 52)))
            
            return company
            
        } catch {
            
            delegate?.companyManagerDidFailWithError(error: error)
            return nil
            
        }
    }
    
}
