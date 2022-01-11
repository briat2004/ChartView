//
//  ChartViewController.swift
//  CAShapeLayerDemo
//
//  Created by BruceWu on 2022/1/6.
//

import UIKit

class ChartViewController: UIViewController {
    
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
    
    var cview: ChartView?
    var c = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        cview = ChartView(frame: .zero, animationDuration: 0)
        cview?.layer.borderColor = UIColor.blue.cgColor
        cview?.backgroundColor = .black
        cview?.clipsToBounds = true
        cview?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(cview!)
        cview?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        cview?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        cview?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        cview?.heightAnchor.constraint(equalTo: cview!.widthAnchor).isActive = true
        
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
        var a: [Float]?
        var b: [Float]?
        if c == 0 {
            a = [95,20,55,44,23,4,55,63,33,44,22, 44]
            b = [50,0,2,33,56,2,17,88,91,37]
            c += 1
        } else if c == 1 {
            a = [50,20,77,34,23,15,22,34,11,25]
            b = [99,80,26,2,54,10,70,100,15,55]
            c += 1
        } else if c == 2 {
            a = [6,8,53,45,22,1,6,100,96,55]
            b = [0,0,2,13,10,2,2,32,44,85]
            c = 0
        }
        
        guard let cview = cview , let a = a, let b = b else { return }
        
        for (count, item) in a.enumerated() {
            cview.number.append(item)
        }
        
        for (count, item) in b.enumerated() {
            cview.numberTop.append(item)
        }
        
        cview.startDraw()
        
        //動畫執行完後
        self.button.isSelected = true
        self.button.backgroundColor = .blue
        cview.complition = { [weak self] in
            DispatchQueue.main.async {
                self?.button.isSelected = false
                self?.button.backgroundColor = .red
            }
        }
    }
}


