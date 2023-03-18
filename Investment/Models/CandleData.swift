//
//  CandleData.swift
//  Investment
//
//  Created by Yedige Ashirbek on 18.03.2023.
//

import Foundation

struct CandleData: Decodable {
    
    var c: [Double]
    var s: String
    var t: [Int]
    
}
