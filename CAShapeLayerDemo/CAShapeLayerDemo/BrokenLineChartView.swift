//
//  BrokenLineChartView.swift
//  CAShapeLayerDemo
//
//  Created by BruceWu on 2022/1/5.
//

import UIKit

protocol BrokenLineChartViewDelegate: NSObject {
    func brokenLineChartViewDidSelect(view: BrokenLineChartView, type: LineType, index: Int)
}

class BrokenLineChartView: ChartBaseView {
    
    weak var blcDelegate: BrokenLineChartViewDelegate?
    var shapeLayerTop: CAShapeLayer?
    private var pathTop: UIBezierPath?
    var shapeLayer: CAShapeLayer?
    private var path: UIBezierPath?
    open var baseNumber: Float? //曲線基數調整高度比例
    private var buttons = [UIButton]()
    private var labels = [UILabel]()
    open var isHiddenLabel = false {
        didSet {
            _ = labels.map({$0.isHidden = isHiddenLabel})
        }
    }
    open var isHiddenButton = false {
        didSet {
            _ = buttons.map({$0.isHidden = isHiddenButton})
        }
    }
    open var complition: (() -> ())?
    
    //動畫
    private let animation = CABasicAnimation(keyPath: "strokeEnd")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.type = .broken
        shapeLayer = CAShapeLayer()
        shapeLayer?.fillColor = UIColor.clear.cgColor
        shapeLayer?.strokeColor = UIColor.red.cgColor
        path = UIBezierPath()
        self.layer.addSublayer(shapeLayer!)
        
        shapeLayerTop = CAShapeLayer()
        shapeLayerTop?.fillColor = UIColor.clear.cgColor
        shapeLayerTop?.strokeColor = UIColor.green.cgColor
        pathTop = UIBezierPath()
        self.layer.addSublayer(shapeLayerTop!)
        
    }
    
    convenience init(frame: CGRect, animationDuration: CFTimeInterval?, padding: CGFloat?) {
        self.init(frame: frame)
        animation.fromValue = 0.0
        animation.toValue = 1.0
        if let animationDuration = animationDuration {
            animation.duration = animationDuration
        }
        if let padding = padding {
            self.padding = padding
        }
    }
    
    private func setPercentOf() {
        guard let baseNumber = baseNumber else { return }
        number = number.map({($0 * 100.0) / baseNumber})
        numberTop = numberTop.map({($0 * 100.0) / baseNumber})
    }
    
    private func removeAllButtons() {
        _ = buttons.map({$0.removeFromSuperview()})
        _ = labels.map({$0.removeFromSuperview()})
        buttons.removeAll()
        labels.removeAll()
    }
    
    private func setButtons(point: CGPoint, type: LineType, index: Int) {
        let dot = DotButton()
        dot.touchEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
        dot.type = type
        dot.frame.size = CGSize(width: 10, height: 10)
        dot.center = point
        switch type {
        case .red:
            dot.layer.borderColor = UIColor.red.cgColor
        case .green:
            dot.layer.borderColor = UIColor.green.cgColor
        }
        dot.backgroundColor = .black
        dot.layer.borderWidth = 2
        dot.layer.cornerRadius = 5
        dot.tag = 1000 + index
        dot.isHidden = isHiddenButton
        dot.addTarget(self, action: #selector(buttonClicked), for: .touchDown)
        self.addSubview(dot)
        buttons.append(dot)
        
        let infoLabel = UILabel()
        infoLabel.frame.size = CGSize(width: 50, height: 20)
        infoLabel.center = CGPoint(x: point.x, y: point.y - 10)
        infoLabel.textColor = .white
        infoLabel.font = UIFont.systemFont(ofSize: 10)
        infoLabel.isUserInteractionEnabled = false
        infoLabel.isHidden = isHiddenLabel
        switch type {
        case .red:
            infoLabel.text = String(number[index])
            infoLabel.textAlignment = index < 1 ? .right : (index + 1 == number.count) ? .left : .center
        case .green:
            infoLabel.text = String(numberTop[index])
            infoLabel.textAlignment = index < 1 ? .right : index + 1 == numberTop.count ? .left : .center
        }
        self.addSubview(infoLabel)
        labels.append(infoLabel)
    }
    
    @objc func buttonClicked(button: UIButton) {
        let button = button as? DotButton
        guard let delegate = blcDelegate, let type = button?.type, let index = button?.tag else { return }
        delegate.brokenLineChartViewDidSelect(view: self, type: type, index: index - 1000)
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let isNumberBiggerThanZero = number.filter({$0 > 0})
        let isNumberTopiggerThanZero = numberTop.filter({$0 > 0})
        guard isNumberBiggerThanZero.count > 0 || isNumberTopiggerThanZero.count > 0 else { return }
        removeAllButtons()
        shapeLayer?.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.contentSize)
        shapeLayerTop?.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: self.contentSize)
        shapeLayerTop?.lineWidth = 1.5
        shapeLayer?.lineWidth = 1.5
        self.setPercentOf() //將傳入的陣列算出以baseNumber為基底的百分比，baseNumber預設為100。
//        startDrawCBView()
        path?.removeAllPoints()
        pathTop?.removeAllPoints()
        //動畫開始
        CATransaction.begin()
        
        // start draw
        drawLines(type: .red, array: number, rect: rect, path: path)
        drawLines(type: .green, array: numberTop, rect: rect, path:  pathTop)
        
        CATransaction.setCompletionBlock(complition)
        
        shapeLayer?.add(animation, forKey: "myStroke")
        shapeLayerTop?.add(animation, forKey: "myStroke2")
        CATransaction.commit()
    }
    
    private func drawLines(type: LineType, array: [Float], rect: CGRect, path: UIBezierPath?) {
        guard let baseLayer = baseLayer else { return }
        let height = baseLayer.frame.height //一格的高度
        if array.count > 0 {
            for i in 0..<array.count {
                let result = array[i]
                let lineHeight = (height / 100.0) * CGFloat(result) //按高度百分比計算結果高度
                let point = CGPoint(x: (rowSpace * CGFloat(i)) + padding, y: (baseLayer.frame.height - CGFloat(lineHeight) + padding))
                if i == 0 {
                    path?.move(to: point)
                }
                path?.addLine(to: point)
                
                setButtons(point: point, type: type, index: i)
            }
        }
        switch type {
        case .red:
            shapeLayer?.path = path?.cgPath
        case .green:
            shapeLayerTop?.path = pathTop?.cgPath
        }
    }
    
    func startDraw() {
        setNeedsDisplay()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

