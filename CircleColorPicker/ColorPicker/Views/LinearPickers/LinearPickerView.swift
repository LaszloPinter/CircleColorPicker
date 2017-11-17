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
open class LinearPickerView: UIView {
    open var animationTimeInSeconds:Double = 0.2
    open var onValueChange: ((CGFloat)->Void)?
    
    internal var storedValue: CGFloat = 0.5
    open var value: CGFloat {
        get{
            return storedValue
        }
        set{
            self.storedValue = newValue
            if isVertical {
                bubbleCenterY.constant = -(storedValue-0.5) * (self.bounds.size.height)
            }else {
                bubbleCenterX.constant = (storedValue-0.5) * (self.bounds.size.width)
            }
        }
        
    }
    
    @IBOutlet var contentView: UIView!
    @IBOutlet open weak var bubbleView: UIImageView!
    @IBOutlet weak var bubbleWidth: NSLayoutConstraint!
    @IBOutlet weak var bubbleCenterX: NSLayoutConstraint!
    @IBOutlet weak var bubbleCenterY: NSLayoutConstraint!
    
    @IBInspectable var isVertical: Bool = false {
        didSet {
            handleOrientationChange()
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
    
    internal var isBubbleDragged = false
    open var frontLayerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialState()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInitialState()
    }
    
    private func setupInitialState() {
        xibSetup()
        setupFrontLayerView()
        setupBubbleMaskImage()
        
    }
    
    private func xibSetup() {
        contentView = UIView.fromNib(named: String(describing: LinearPickerView.self),
                                     bundle: Bundle(for: LinearPickerView.self), owner: self)!
        contentView!.frame = bounds
        
        contentView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView!)
    }
    
    open func handleOrientationChange() {
        print("Subclasses of LinearPickerView should override handleOrientationChange() function.")
    }
    
    open func createFrontLayerView() -> UIView{
        print("Subclasses of LinearPickerView should override createFrontLayerView() function.")
        return UIView(frame: CGRect.init(origin: CGPoint.zero, size: self.bounds.size))
    }
    
    private func setupFrontLayerView() {
        frontLayerView = createFrontLayerView()
        frontLayerView.backgroundColor = UIColor.clear
        frontLayerView.setNeedsDisplay()
        contentView.insertSubview(frontLayerView, belowSubview: bubbleView)
    }
    
    public func setupBubbleMaskImage(image: UIImage? = Optional.none) {
        if let image = image {
            bubbleView.image = image
        }else {
            let podBundle = Bundle(for: LinearPickerView.self)
            if let bundleUrl = podBundle.url(forResource: "CircleColorPicker", withExtension: "bundle"),
                let bundle = Bundle(url: bundleUrl) {
                let retrievedImage = UIImage(named: "ringMask", in: bundle, compatibleWith: nil)
                bubbleView.image = retrievedImage
            }
        }
    }
    
    override open func layoutSubviews() {
        frontLayerView.frame = CGRect.init(origin: CGPoint.zero, size: self.bounds.size)
        let cornerRadius = min(self.bounds.size.width, self.bounds.size.height) * 0.5
        contentView.layer.cornerRadius = cornerRadius
        self.layer.cornerRadius = cornerRadius
        frontLayerView.layer.cornerRadius = cornerRadius
        frontLayerView.clipsToBounds = true
    }
}
