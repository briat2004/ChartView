//
//  ViewController.swift
//  CAShapeLayerDemo
//
//  Created by BruceWu on 2021/1/28.
//

import UIKit

class ViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        delegate = self
        let vca = ChartViewController()
        let vcb = BrokenLineChartViewController()
        self.setViewControllers([vca, vcb], animated: true)
        self.tabBar.backgroundColor = .gray
        let titles = ["ChartViewController", "BrokenLineChartViewController"]
        for i in 0..<self.viewControllers!.count {
            self.tabBar.items?[i].title = titles[i]
        }
    }
}

