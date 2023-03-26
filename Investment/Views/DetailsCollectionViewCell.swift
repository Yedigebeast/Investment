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
    
    var delegate: DetailsCollectionViewCellDelegate?
    
    var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: 18)
        label.text = "Chart"
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
        
        contentView.addSubview(button)
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
              
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            button.leftAnchor.constraint(equalTo: label.leftAnchor),
            button.topAnchor.constraint(equalTo: label.topAnchor),
            button.bottomAnchor.constraint(equalTo: label.bottomAnchor),
            button.rightAnchor.constraint(equalTo: label.rightAnchor)

        ])
        
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
    }
    
    @objc func buttonPressed() {
     
        delegate?.didButtonPressed(tag: button.tag)
        
    }
    
}
