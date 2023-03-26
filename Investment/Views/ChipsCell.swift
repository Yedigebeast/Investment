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
    
    var delegate: ChipsCellDelegate?
    
    var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 12)
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
        
        contentView.layer.cornerRadius = 12
        
        contentView.addSubview(button)
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
              
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            button.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.rightAnchor.constraint(equalTo: contentView.rightAnchor)

        ])
        
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
    }
    
    @IBAction func buttonPressed() {
        
        delegate?.didChipsButtonPressed(tag: button.tag)
        
    }
}
