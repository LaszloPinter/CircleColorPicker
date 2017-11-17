//
//  SaturationPickerView.swift
//  CircleColorPicker
//
//  Created by Laszlo Pinter on 11/17/17.
//  Copyright © 2017 Laszlo Pinter. All rights reserved.
//

import UIKit

open class SaturationPickerView: LinearPickerView {

    open override func handleOrientationChange() {
        (frontLayerView as! SaturationPickerView).isVertical = isVertical
    }
    
    open override func createFrontLayerView() -> UIView{
        let frontLayer = SaturationMask(frame: CGRect.init(origin: CGPoint.zero, size: self.bounds.size))
        frontLayer.isVertical = isVertical
        return frontLayer
    }
    
    class SaturationMask: UIView {
        public var isVertical = false
        
        func drawScale(context: CGContext){
            
            let startColor = UIColor.init(hue: 1, saturation: 0, brightness: 1, alpha: 1).cgColor
            let endColor   = UIColor.init(hue: 1, saturation: 0, brightness: 1, alpha: 0).cgColor
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colors = [startColor, endColor] as CFArray
            
            if let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors, locations: nil) {
                var startPoint: CGPoint!
                var endPoint: CGPoint!
                
                if isVertical {
                    startPoint = CGPoint(x: self.bounds.width, y: self.bounds.height)
                    endPoint = CGPoint(x: self.bounds.width, y: 0)
                }else {
                    startPoint = CGPoint(x: 0, y: self.bounds.height)
                    endPoint = CGPoint(x: self.bounds.width, y: self.bounds.height)
                }
                
                context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)
            }
        }
        
        override func draw(_ rect: CGRect) {
            super.draw(rect)
            guard let context = UIGraphicsGetCurrentContext() else {
                return
            }
            drawScale(context: context)
        }
    }
}
