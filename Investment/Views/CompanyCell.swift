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
    
    var companyImage: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 13
        imgView.layer.masksToBounds = true
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.text = "-"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var companyName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 12)
        label.text = "-"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var favouriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "Hate"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var cost: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.text = "-"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var changes: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 12)
        label.text = "-"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc func favouriteButtonPressed() {
        
        delegate?.cellFavouriteButtonPressed(tag: favouriteButton.tag)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        contentView.addSubview(companyImage)
        contentView.addSubview(label)
        contentView.addSubview(companyName)
        contentView.addSubview(favouriteButton)
        contentView.addSubview(cost)
        contentView.addSubview(changes)
        
        NSLayoutConstraint.activate([
              
            companyImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 13),
            companyImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 17),
            companyImage.heightAnchor.constraint(equalToConstant: 65),
            companyImage.widthAnchor.constraint(equalToConstant: 65),
            companyImage.rightAnchor.constraint(equalTo: companyName.leftAnchor, constant: -12),
            companyImage.rightAnchor.constraint(equalTo: label.leftAnchor, constant: -12),
            
            label.rightAnchor.constraint(equalTo: favouriteButton.leftAnchor, constant: -6),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 23),
            label.bottomAnchor.constraint(equalTo: companyName.topAnchor),
            
            favouriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 23),
            favouriteButton.heightAnchor.constraint(equalToConstant: 20),
            favouriteButton.widthAnchor.constraint(equalToConstant: 20),
            
            cost.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -22),
            cost.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 23),
            cost.bottomAnchor.constraint(equalTo: changes.topAnchor),
            
            changes.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -17)

        ])
        
        favouriteButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
        
    }
    
}
