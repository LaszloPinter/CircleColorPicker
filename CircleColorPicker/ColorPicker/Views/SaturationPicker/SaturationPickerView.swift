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

@IBDesignable
open class SaturationPickerView: UIView {
    open var animationTimeInSeconds:Double = 0.2
    internal var isBubbleDragged = false

    var saturationMask: SaturationMask!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var bubbleView: UIImageView!
    @IBOutlet weak var bubbleWidth: NSLayoutConstraint!
    @IBOutlet weak var bubbleCenterX: NSLayoutConstraint!
    @IBOutlet weak var bubbleCenterY: NSLayoutConstraint!
    
    public var saturation: CGFloat = 0.5
    
    @IBInspectable var isVertical: Bool = false {
        didSet {
            saturationMask.isVertical = isVertical
            if isVertical {
                bubbleCenterX.constant = 0
            }else {
                bubbleCenterY.constant = 0
            }
        }
    }
    
    @IBInspectable
    public var bubbleSize: CGFloat = 20.0 {
        didSet {
            bubbleWidth.constant = bubbleSize
            bubbleView.layer.cornerRadius = bubbleSize * 0.5
            setNeedsLayout()
            bubbleView.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupSaturationMaskView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupSaturationMaskView()
    }
    
    private func xibSetup() {
        contentView = UIView.fromNib(named: String(describing: SaturationPickerView.self),
                                     bundle: Bundle(for: self.classForCoder), owner: self)!
        contentView!.frame = bounds
        
        contentView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView!)
    }
    
    func setupSaturationMaskView() {
        saturationMask = SaturationMask(frame: CGRect.init(origin: CGPoint.zero, size: self.bounds.size))
        saturationMask.backgroundColor = UIColor.clear
        saturationMask.isVertical = isVertical
        contentView.addSubview(saturationMask)
    }
    
    public func setupBubbleMaskImage(image: UIImage? = Optional.none) {
        if let image = image {
            bubbleView.image = image
        }else {
            let podBundle = Bundle(for: SaturationPickerView.self)
            if let bundleUrl = podBundle.url(forResource: "CircleColorPicker", withExtension: "bundle"),
                let bundle = Bundle(url: bundleUrl) {
                let retrievedImage = UIImage(named: "ringMask", in: bundle, compatibleWith: nil)
                bubbleView.image = retrievedImage
            }
        }
    }
    
    override open func layoutSubviews() {
        saturationMask.frame = CGRect.init(origin: CGPoint.zero, size: self.bounds.size)
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
