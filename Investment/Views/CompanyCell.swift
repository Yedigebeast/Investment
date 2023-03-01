//
//  CompanyCell.swift
//  Investment
//
//  Created by Yedige Ashirbek on 24.02.2023.
//

import UIKit

protocol CompanyCellDelegate {
    
    func cellFavouriteButtonPressed(tag: Int)
    
}

class CompanyCell: UITableViewCell {
    
    var delegate: CompanyCellDelegate?
    
    @IBOutlet weak var favouriteButton: UIButton!
    @IBOutlet weak var companyImage: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var cost: UILabel!
    @IBOutlet weak var changes: UILabel!

    @IBAction func favouriteButtonPressed(_ sender: UIButton) {
        
        delegate?.cellFavouriteButtonPressed(tag: sender.tag)
        
    }

    override func awakeFromNib() {
        
        super.awakeFromNib()
        companyImage.layer.cornerRadius = companyImage.frame.size.height / 4
        companyImage.layer.masksToBounds = true
        
    }
    
}
