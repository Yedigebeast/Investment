//
//  BalloonMarker.swift
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import Charts
import ChameleonFramework

#if canImport(UIKit)
    import UIKit
#endif

open class BalloonMarker: MarkerImage
{
    @objc open var color: UIColor
    @objc open var arrowSize = CGSize(width: 12, height: 6)
    @objc open var font: UIFont
    @objc open var textColor: UIColor
    @objc open var insets: UIEdgeInsets
    @objc open var minimumSize = CGSize()
    
    fileprivate var label: NSMutableAttributedString?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _drawAttributes = [NSAttributedString.Key : Any]()
    
    @objc public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets)
    {
        self.color = color
        self.font = font
        self.textColor = textColor
        self.insets = insets
        
        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
        super.init()
    }
    
    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint
    {
        var offset = self.offset
        var size = self.size

        if size.width == 0.0 && image != nil
        {
            size.width = image!.size.width
        }
        if size.height == 0.0 && image != nil
        {
            size.height = image!.size.height
        }

        let width = size.width
        let height = size.height
        let padding: CGFloat = 1.0

        var origin = point
        origin.x -= width / 2
        origin.y -= height

        if origin.x + offset.x < 0.0
        {
            offset.x = -origin.x + padding
        }
        else if let chart = chartView,
            origin.x + width + offset.x > chart.bounds.size.width
        {
            offset.x = chart.bounds.size.width - origin.x - width - padding
        }

        if origin.y + offset.y < 0
        {
            offset.y = height + padding;
        }
        else if let chart = chartView,
            origin.y + height + offset.y > chart.bounds.size.height
        {
            offset.y = chart.bounds.size.height - origin.y - height - padding
        }

        return offset
    }
    
    open override func draw(context: CGContext, point: CGPoint)
    {
        guard let label = label else { return }
        
        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size
        
        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2
        rect.origin.y -= size.height
                
        if Constants.phoneViewWidth - point.x <= size.width / 2 {
            
            rect.origin.x -= size.width / 2
            
        }
        
        context.saveGState()
        
        context.setFillColor(color.cgColor)

        if offset.y > 0 {
                    
            context.beginPath()
            let rect2 = CGRect(x: rect.origin.x, y: rect.origin.y + arrowSize.height, width: rect.size.width, height: rect.size.height - arrowSize.height)
            let clipPath = UIBezierPath(roundedRect: rect2, cornerRadius: 16.0).cgPath
            context.addPath(clipPath)
            context.closePath()
            context.fillPath()
            
            // arraow vertex
            context.beginPath()
            let p1 = CGPoint(x: rect.origin.x + rect.size.width / 2.0 - arrowSize.width / 2.0, y: rect.origin.y + arrowSize.height + 1)
            context.move(to: p1)
            context.addLine(to: CGPoint(x: p1.x + arrowSize.width, y: p1.y))
            context.addLine(to: CGPoint(x: point.x, y: point.y))
            context.addLine(to: p1)

            context.fillPath()
            
        } else {
            context.beginPath()
            let rect2 = CGRect(x: rect.origin.x, y: rect.origin.y, width: rect.size.width, height: rect.size.height - arrowSize.height)
            let clipPath = UIBezierPath(roundedRect: rect2, cornerRadius: 16.0).cgPath
            context.addPath(clipPath)
            context.closePath()
            context.fillPath()

            // arraow vertex
            context.beginPath()
            let p1 = CGPoint(x: rect.origin.x + rect.size.width / 2.0 - arrowSize.width / 2.0, y: rect.origin.y + rect.size.height - arrowSize.height - 1)
            context.move(to: p1)
            context.addLine(to: CGPoint(x: p1.x + arrowSize.width, y: p1.y))
            context.addLine(to: CGPoint(x: point.x, y: point.y))
            context.addLine(to: p1)

            context.fillPath()
        }
        
        if offset.y > 0 {
            rect.origin.y += self.insets.top + arrowSize.height
        } else {
            rect.origin.y += self.insets.top
        }
        
        rect.size.height -= self.insets.top + self.insets.bottom
        
        UIGraphicsPushContext(context)
        
        label.draw(in: rect)
        
        UIGraphicsPopContext()
        
        context.restoreGState()
    }
    
    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight)
    {
        let selectedXValue = NSDate(timeIntervalSince1970: (entry.x + 6 * 60 * 60))

        var selectedYValue = "\(entry.y)"
        selectedYValue = selectedYValue.addingSpaceInNumber()

        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = "dd MMM yyyy"

        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        var str = ""
        let mutableString = NSMutableAttributedString(string: str)
        
        let labelAttributes: [NSAttributedString.Key: Any]? = [
            
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: font.fontName, size: 16)!,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue) : HexColor("#FFFFFF")!,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.paragraphStyle.rawValue) : paragraphStyle

        ]
        str = "$\(selectedYValue) \n"
        let addedString = NSAttributedString(string: str, attributes: labelAttributes)
        mutableString.append(addedString)
        
        let labelAttributes1: [NSAttributedString.Key: Any]? = [
            
            NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: font.fontName, size: 12)!,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue) : HexColor("#BABABA")!,
            NSAttributedString.Key(rawValue: NSAttributedString.Key.paragraphStyle.rawValue) : paragraphStyle
            
        ]
        str = dateFormatter.string(from: selectedXValue as Date).lowercased()
        let addedString1 = NSAttributedString(string: str, attributes: labelAttributes1)
        mutableString.append(addedString1)
        
//        customMarker.price.text = "$\(selectedYValue)"
//        customMarker.date.text = dateFormatter.string(from: selectedXValue as Date).lowercased()
        
        setLabel(mutableString)
    }
    
    @objc open func setLabel(_ newLabel: NSMutableAttributedString)
    {
        label = newLabel
        _labelSize = label!.size()
        
//        _drawAttributes.removeAll()
//        _drawAttributes[.font] = self.font
//        _drawAttributes[.paragraphStyle] = _paragraphStyle
//        _drawAttributes[.foregroundColor] = self.textColor
                
        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
}
