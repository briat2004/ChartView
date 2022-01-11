//
//  BrokenLineChartViewController.swift
//  CAShapeLayerDemo
//
//  Created by BruceWu on 2022/1/6.
//

import UIKit

class BrokenLineChartViewController: UIViewController, BrokenLineChartViewDelegate, ChartBaseViewDelegate {
    
    var button: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .red
        btn.setTitle("Press", for: .normal)
        btn.setTitle("Loading...", for: .selected)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        return btn
    }()
    
    var infoLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = .clear
        lbl.textColor = .black
        lbl.textAlignment = .center
        return lbl
    }()
    
    var cview: BrokenLineChartView?
    var c = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        cview = BrokenLineChartView(frame: .zero, animationDuration: 0, padding: 40)
        cview?.blcDelegate = self
        cview?.cbDelegate = self
        cview?.layer.borderColor = UIColor.blue.cgColor
        cview?.backgroundColor = .black
        cview?.clipsToBounds = false
        cview?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cview!)
        cview?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        cview?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        cview?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        cview?.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
        
        self.view.addSubview(button)
        button.leadingAnchor.constraint(equalTo: cview!.leadingAnchor).isActive = true
        button.topAnchor.constraint(equalTo: cview!.bottomAnchor, constant: 20).isActive = true
        button.widthAnchor.constraint(equalToConstant: 100).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        self.view.addSubview(infoLabel)
        infoLabel.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 10).isActive = true
        infoLabel.topAnchor.constraint(equalTo: button.topAnchor).isActive = true
        infoLabel.bottomAnchor.constraint(equalTo: button.bottomAnchor).isActive = true
        infoLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    @objc func btnAction() {
        cview?.number.removeAll()
        cview?.numberTop.removeAll()
        cview?.baseNumber = 100
        var a: [Float] = []
        var b: [Float] = []
        
        if c == 0{
            for _ in 0...99 {
                cview?.number.append(Float(arc4random_uniform(100)))
                cview?.numberTop.append(Float(arc4random_uniform(100)))
            }
            c += 1
        } else if c == 1 {
            for _ in 0...50 {
                cview?.number.append(Float(arc4random_uniform(100)))
                cview?.numberTop.append(Float(arc4random_uniform(100)))
            }
            c = 0
        }
        cview?.startDraw()
        
        //動畫執行完後
        self.button.isSelected = true
        self.button.backgroundColor = .blue
        cview?.complition = { [weak self] in
            DispatchQueue.main.async {
                self?.button.isSelected = false
                self?.button.backgroundColor = .red
            }
        }
    }
    
    func brokenLineChartViewDidSelect(view: BrokenLineChartView, type: LineType, index: Int) {
        switch type {
        case .red:
            infoLabel.backgroundColor = .red
            infoLabel.text = String(view.number[index])
        case .green:
            infoLabel.backgroundColor = .green
            infoLabel.text = String(view.numberTop[index])
        }
    }
    
    func getBoundaryPoint(view: UIScrollView, left: CGPoint?, right: CGPoint?, top: CGPoint?, bottom: CGPoint?, index: Int) {
        if let left = left {
            let lLabel = UILabel(frame: CGRect(x: left.x - 20, y: left.y, width: 20, height: 20))
            lLabel.font = UIFont.systemFont(ofSize: 9)
            lLabel.textColor = .white
            lLabel.textAlignment = .center
            let num = index * 10
            lLabel.text = String(num)
            view.addSubview(lLabel)
        }
        
        if let top = top {
            let tLabel = UILabel(frame: CGRect(x: top.x, y: top.y - 20, width: 20, height: 20))
            tLabel.font = UIFont.systemFont(ofSize: 9)
            tLabel.textColor = .white
            tLabel.textAlignment = .center
            let num = index * 10
            tLabel.text = String(num)
            view.addSubview(tLabel)
        }
    }
}
