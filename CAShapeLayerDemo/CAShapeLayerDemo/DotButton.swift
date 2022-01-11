//
//  DotButton.swift
//  CAShapeLayerDemo
//
//  Created by BruceWu on 2022/1/5.
//

import UIKit

class DotButton: UIButton {
    var touchEdgeInsets:UIEdgeInsets?
    var type: LineType?
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var frame = self.bounds
        if let touchEdgeInsets = touchEdgeInsets {
            frame = frame.inset(by: touchEdgeInsets)
        }
        
        return frame.contains(point)
    }

}
