//
//  SearchCell.swift
//  Investment
//
//  Created by Yedige Ashirbek on 07.03.2023.
//

import UIKit
import ChameleonFramework

protocol SearchCellDelegate {
    
    func searchCellPressed(tag: Int, viewTag: Int)
    
}

class SearchCell: UICollectionViewCell {
    
    var collectionViewTag: Int = 1
    var delegate: SearchCellDelegate?
    
    var cellLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 12)
        label.text = "-"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var button: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = HexColor("#F0F4F7")
        
        contentView.addSubview(cellLabel)
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
              
            cellLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            cellLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cellLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            cellLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            
            button.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.rightAnchor.constraint(equalTo: contentView.rightAnchor)

        ])
        
        button.addTarget(self, action: #selector(searchButtonPressed), for: .touchUpInside)
        
    }
    
    @objc func searchButtonPressed() {
        
        delegate?.searchCellPressed(tag: button.tag, viewTag: collectionViewTag)
        
    }
    
}
