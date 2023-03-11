//
//  SearchCell.swift
//  Investment
//
//  Created by Yedige Ashirbek on 07.03.2023.
//

import UIKit

protocol SearchCellDelegate {
    
    func searchCellPressed(tag: Int, viewTag: Int)
    
}

class SearchCell: UICollectionViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    var collectionViewTag: Int = 1
    var delegate: SearchCellDelegate?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        delegate?.searchCellPressed(tag: sender.tag, viewTag: collectionViewTag)
        
    }
    
}
