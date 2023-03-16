//
//  ChipsCell.swift
//  Investment
//
//  Created by Yedige Ashirbek on 16.03.2023.
//

import UIKit

protocol ChipsCellDelegate {
    
    func didChipsButtonPressed(tag: Int)
    
}

class ChipsCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    var delegate: ChipsCellDelegate?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        delegate?.didChipsButtonPressed(tag: sender.tag)
        
    }
}
