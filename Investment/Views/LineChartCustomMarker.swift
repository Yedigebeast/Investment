//
//  LineChartCustomMarker.swift
//  Investment
//
//  Created by Yedige Ashirbek on 19.03.2023.
//

import Charts

class LineChartCustomMarker: MarkerView {
    
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var selectedCircle: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    
    func initUI(){
        
        Bundle.main.loadNibNamed("LineChartCustomMarker", owner: self, options: nil)
        addSubview(contentView)
        
        background.layer.cornerRadius = 16
        self.frame = CGRect(x: 0, y: 0, width: 120, height: 105)
        self.offset = CGPoint(x: -(self.frame.width / 2), y: -self.frame.height + 8)
    }
    
}
