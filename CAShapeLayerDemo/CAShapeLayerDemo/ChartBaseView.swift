//
//  ChartBaseView.swift
//  CAShapeLayerDemo
//
//  Created by BruceWu on 2022/1/5.
//

import UIKit

enum LineType: String {
    case red
    case green
}
enum ClassType {
    case broken
    case chart
}

protocol ChartBaseViewDelegate: NSObject {
    func getBoundaryPoint(view: UIScrollView, left: CGPoint?, right: CGPoint?, top: CGPoint?, bottom: CGPoint?, index: Int)
}

class ChartBaseView: UIScrollView {
    
    weak var cbDelegate: ChartBaseViewDelegate?
    open var number: [Float] = []
    open var numberTop: [Float] = []
    var rowSpace: CGFloat = 0
    var padding: CGFloat = 20
    var type: ClassType = .chart
    var numCount: Int {
        get {
            switch type {
            case .chart:
                return number.count + 1
            case .broken:
                return number.count - 1
            }
        }
    }
    
    var numTopCount: Int {
        get {
            switch type {
            case .chart:
                return numberTop.count + 1
            case .broken:
                return numberTop.count - 1
            }
        }
    }
    
    final var baseLayer: CAShapeLayer?
    final var basePath: UIBezierPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseLayer = CAShapeLayer()
        baseLayer?.fillColor = UIColor.black.cgColor
        baseLayer?.lineWidth = 1
        baseLayer?.strokeColor = UIColor.blue.cgColor
        basePath = UIBezierPath()
        self.layer.addSublayer(baseLayer!)
    }
    
    override func draw(_ rect: CGRect) {
        guard number.filter({$0 > 0}).count > 0 || numberTop.filter({$0 > 0}).count > 0 else { return }
        rowSpace = (rect.height - (padding * 2)) / CGFloat(10)
        self.contentSize = CGSize(width: (rowSpace * CGFloat(number.count > numberTop.count ? numCount : numTopCount) + padding * 2), height: rect.height)
        baseLayer?.frame = CGRect(origin: CGPoint(x: padding, y: padding), size: CGSize(width: self.contentSize.width - (padding * 2), height: self.contentSize.height - (padding * 2)))
        guard let baseLayer = baseLayer else { return }
        let count = lround(baseLayer.frame.width / rowSpace)
        self.basePath?.removeAllPoints()
        _ = self.subviews.map({$0.removeFromSuperview()})
        
        if number.count > 0 || numberTop.count > 0 {
            
            //橫線
            for i in 0..<Int(10) + 1 {
                basePath?.move(to: CGPoint(x: 0, y: rowSpace * CGFloat(i)))
                basePath?.addLine(to: CGPoint(x: baseLayer.frame.maxX - padding, y: rowSpace * CGFloat(i)))
                if let cbDelegate = cbDelegate {
                    cbDelegate.getBoundaryPoint(view: self,
                                                left: CGPoint(x: baseLayer.frame.origin.x, y: baseLayer.frame.height - (rowSpace * CGFloat(i - 1))),
                                                right: CGPoint(x: baseLayer.frame.maxX - padding, y: baseLayer.frame.height - (rowSpace * CGFloat(i - 1))),
                                                top: nil,
                                                bottom: nil,
                                                index: i)
                }
            }
            
            //直線
            for i in 0...Int(count) {
                basePath?.move(to: CGPoint(x: rowSpace * CGFloat(i), y: 0))
                basePath?.addLine(to: CGPoint(x: rowSpace * CGFloat(i), y: baseLayer.frame.maxY - padding))
                if let cbDelegate = cbDelegate {
                    cbDelegate.getBoundaryPoint(view: self,
                                                left: nil,
                                                right: nil,
                                                top: CGPoint(x: rowSpace * CGFloat(i + 1), y: padding),
                                                bottom: CGPoint(x: rowSpace * CGFloat(i + 1), y: baseLayer.frame.maxY),
                                                index: i)
                }
            }
            
            baseLayer.path = basePath?.cgPath
        }
    }
    
    func startDrawCBView() {
        setNeedsDisplay()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

