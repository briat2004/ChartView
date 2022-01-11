//
//  ChartView.swift
//  CAShapeLayerDemo
//
//  Created by BruceWu on 2021/12/17.
//

import UIKit

class ChartView: ChartBaseView {
    
    private var shapeLayerTop: CAShapeLayer?
    private var pathTop: UIBezierPath?
    private var shapeLayer: CAShapeLayer?
    private var path: UIBezierPath?
    open var baseNumber: Float?
    open var complition: (() -> ())?
    
    //動畫
    private let animation = CABasicAnimation(keyPath: "strokeEnd")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.type = .chart
        shapeLayer = CAShapeLayer()
        shapeLayer?.fillColor = UIColor.red.cgColor
        shapeLayer?.strokeColor = UIColor.red.cgColor
        path = UIBezierPath()
        self.layer.addSublayer(shapeLayer!)
        
        shapeLayerTop = CAShapeLayer()
        shapeLayerTop?.fillColor = UIColor.green.cgColor
        shapeLayerTop?.strokeColor = UIColor.green.cgColor
        pathTop = UIBezierPath()
        self.layer.addSublayer(shapeLayerTop!)
        
    }
    
    convenience init(frame: CGRect, animationDuration: CFTimeInterval) {
        self.init(frame: frame)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = animationDuration
    }
    
    private func setPercentOf() {
        guard let baseNumber = baseNumber else { return }
        number = number.map({($0 * 100.0) / baseNumber})
        numberTop = numberTop.map({($0 * 100.0) / baseNumber})
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        shapeLayer?.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.contentSize)
        shapeLayerTop?.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.contentSize)
        shapeLayerTop?.lineWidth = rect.width / 20
        shapeLayer?.lineWidth = rect.width / 20
        //將傳入的陣列算出以baseNumber為基底的百分比，baseNumber預設為100。
        self.setPercentOf()
//        startDrawCBView()
        path?.removeAllPoints()
        pathTop?.removeAllPoints()
        //動畫開始
        CATransaction.begin()
        
        // start draw
        drawLines(type: .red, array: number, rect: rect, path: path)
        drawLines(type: .green, array: numberTop, rect: rect, path: pathTop)
        
        CATransaction.setCompletionBlock(complition)
        
        shapeLayer?.add(animation, forKey: "myStroke")
        shapeLayerTop?.add(animation, forKey: "myStroke2")
        CATransaction.commit()
    }
    
    private func drawLines(type: LineType, array: [Float], rect: CGRect, path: UIBezierPath?) {
        guard let baseLayer = baseLayer else { return }
        let height = baseLayer.frame.height //一格的高度
        if array.count > 0 {
            for i in 1..<array.count + 1 {
                let result = array[i - 1]
                let lineHeight = (height / 100.0) * CGFloat(result) //按高度百分比計算結果高度
                path?.move(to: CGPoint(x: rowSpace * CGFloat(i) + padding, y: baseLayer.frame.height + padding))
                path?.addLine(to: CGPoint(x: rowSpace * CGFloat(i) + padding, y: baseLayer.frame.height - CGFloat(lineHeight) + padding))
            }
        }
        
        switch type {
        case .red:
            shapeLayer?.path = path?.cgPath
        case .green:
            shapeLayerTop?.path = path?.cgPath
        }
    }
    
    func startDraw() {
        setNeedsDisplay()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
