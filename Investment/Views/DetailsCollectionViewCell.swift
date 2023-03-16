//
//  DetailsCollectionViewCell.swift
//  Investment
//
//  Created by Yedige Ashirbek on 15.03.2023.
//

import UIKit

protocol DetailsCollectionViewCellDelegate {
    
    func didButtonPressed(tag: Int)
    
}

class DetailsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
    var delegate: DetailsCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
     
        delegate?.didButtonPressed(tag: sender.tag)
        
    }
    
}
