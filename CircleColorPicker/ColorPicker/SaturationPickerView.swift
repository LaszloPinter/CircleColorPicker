//Copyright (c) 2017 Laszlo Pinter
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.
//

import UIKit

class SaturationPickerView: UIView {
    
    var saturationMask: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMaskView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupMaskView()
    }
    
    func setupMaskView() {
        saturationMask = SaturationMask(frame: CGRect.init(origin: CGPoint.zero, size: self.bounds.size))
        saturationMask.backgroundColor = UIColor.clear
        self.addSubview(saturationMask)
    }
    
    override func layoutSubviews() {
        saturationMask.frame = CGRect.init(origin: CGPoint.zero, size: self.bounds.size)
    }
    
    class SaturationMask: UIView {
        func drawScale(context: CGContext){
            
            let startColor = UIColor.init(hue: 1, saturation: 0, brightness: 1, alpha: 1).cgColor
            let endColor   = UIColor.init(hue: 1, saturation: 0, brightness: 1, alpha: 0).cgColor
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let colors = [startColor, endColor] as CFArray
            
            if let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors, locations: nil) {
                let startPoint = CGPoint(x: 0, y: self.bounds.height)
                let endPoint = CGPoint(x: self.bounds.width, y: self.bounds.height)
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
