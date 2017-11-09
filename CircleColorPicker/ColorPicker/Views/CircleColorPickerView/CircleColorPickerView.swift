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
open class CircleColorPickerView: UIView {
    var contentView : UIView?
    public weak var delegate: CircleColorPickerViewDelegate?
    
    open var animationTimeInSeconds:Double = 0.2
    
    public var saturation: CGFloat = 1.0 {
        didSet{
            onColorChanged()
        }
    }
    
    public var hue: CGFloat = 0 {
        didSet{
            onColorChanged()
        }
    }
    
    @IBInspectable
    public var rainbowWidth: CGFloat = 8.0 {
        didSet {
            updateRainbowMetrics()
            updateBubbleMetrics()
        }
    }
    
    @IBInspectable
    public var bubbleRadius:CGFloat = 18.0 {
        didSet{
            colorBubbleView.bubbleRadius = bubbleRadius
        }
    }

    @IBInspectable
    public var color: CGColor {
        get {
            return UIColor(hue: hue, saturation: saturation, brightness: 1, alpha: 1).cgColor
        }
        
        set {
            let color = UIColor.init(cgColor: newValue)
            var h: CGFloat = 0, s: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
            color.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
            self.hue = h
            self.saturation = s
            setBubbleAngleForCurrentHue()
            updateSaturationPicker()
            updateAllViews()
            onColorChanged()
        }
    }
    
    @IBInspectable
    public var centerDiameter: CGFloat = 80.0 {
        didSet {
            sampleViewRadius.constant = centerDiameter
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    public var centerRingWidth: CGFloat = 8.0 {
        didSet {
            colorSampleView.ringWidth = centerRingWidth
            colorSampleView.setNeedsDisplay()
        }
    }

    @IBOutlet weak var rainbowCircleView: RainbowCircleView!
    @IBOutlet weak var colorBubbleView: ColorBubbleView!
    var saturationPickerView: SaturationPickerView?
    
    @IBOutlet weak var colorSampleView: ColorSampleCircleView!

    
    @IBOutlet weak var sampleViewRadius: NSLayoutConstraint!

    
    internal var isBubbleDragged = false

    override public init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupMaskImages()
        onStart()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupMaskImages()
        onStart()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupMaskImages()
    }
    
    open override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow != nil {
            updateAllViews()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        updateBubbleMetrics()
        updateRainbowMetrics()
    }
    
    public func setupMaskImages(image: UIImage? = Optional.none) {
        if let image = image {
            colorBubbleView.ringMaskImageView.image = image
        }else {
            let podBundle = Bundle(for: CircleColorPickerView.self)
            if let bundleUrl = podBundle.url(forResource: "CircleColorPicker", withExtension: "bundle"),
                let bundle = Bundle(url: bundleUrl) {
                let retrievedImage = UIImage(named: "ringMask", in: bundle, compatibleWith: nil)
                colorBubbleView.ringMaskImageView.image = retrievedImage
            }
        }
    }
    
    private func xibSetup() {
        contentView = UIView.fromNib(named: String(describing: CircleColorPickerView.self),
                                     bundle: Bundle(for: self.classForCoder), owner: self)!
        contentView!.frame = bounds
        
        contentView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView!)
    }
    
    private func onStart() {
        updateBubbleMetrics()
        updateRainbowMetrics()
    }
    
    private func updateBubbleMetrics() {
        colorBubbleView.bubbleRadius = bubbleRadius
        colorBubbleView.rainbowRadius = self.rainbowRadius 
    }
    
    private func updateRainbowMetrics() {
        rainbowCircleView.rainbowWidth = rainbowWidth
        rainbowCircleView.rainbowRadius = self.rainbowRadius
    }
    
    private func onColorChanged() {
        updateAllViews()
        
        delegate?.onColorChanged(newColor: self.color)
    }
    
    private func updateAllViews() {
        let color = UIColor.init(cgColor: self.color)
        let fullSaturationColor = UIColor.init(hue: self.hue, saturation: 1, brightness: 1, alpha: 1)
        colorSampleView.setSampleColor(color: color)
        colorBubbleView.setBubbleColor(color: fullSaturationColor)
        saturationPickerView?.backgroundColor = fullSaturationColor
        saturationPickerView?.bubbleView.backgroundColor = color
    }
    
    private func setBubbleAngleForCurrentHue(){
        self.colorBubbleView.transform = CGAffineTransform(rotationAngle: getRadians(for: hue))
    }
    
    private func updateSaturationPicker(){
        //saturationKnobPosition.constant = (saturation - 0.5) * saturationPickerView.bounds.width
    }
}

extension CircleColorPickerView {
    var origo: CGPoint {
        get{
            return CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        }
    }
    
    var rainbowRadius: CGFloat {
        get{
            let smaller = min(self.frame.size.width, self.frame.size.height)
            
            return smaller * 0.9 * 0.5
        }
    }
    
    func getRadians(for hue: CGFloat) -> CGFloat {
        return hue * 2 * CGFloat.pi
    }
}
