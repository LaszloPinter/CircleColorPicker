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

class ColorBubbleView: UIView {
    var contentView : UIView?

    var bubbleRadius: CGFloat = 18.0 {
        didSet{
            bubbleWidth.constant = bubbleRadius * 2
            bubbleBackgroundView.layer.cornerRadius = bubbleRadius
            setNeedsLayout()
        }
    }
    
    var rainbowRadius: CGFloat = 8.0 {
        didSet{
            bubblePosition.constant = rainbowRadius
            setNeedsLayout()
        }
    }
    
    @IBOutlet weak var bubblePosition: NSLayoutConstraint!
    
    @IBOutlet weak var bubbleBackgroundView: UIView!
    @IBOutlet weak var ringMaskImageView: UIImageView!
    @IBOutlet weak var bubbleWidth: NSLayoutConstraint!
    @IBOutlet weak var connectStringView: UIView!
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
        setupMaskImage()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
        setupMaskImage()
    }
    
    func setBubbleColor(color: UIColor){
        bubbleBackgroundView.backgroundColor = color
        connectStringView.backgroundColor = color.withAlphaComponent(0.5)
    }
    
    func setupMaskImage() {
        let podBundle = Bundle(for: ColorBubbleView.self)
        if let bundleUrl = podBundle.url(forResource: "CircleColorPicker", withExtension: "bundle"),
            let bundle = Bundle(url: bundleUrl) {
            let retrievedImage = UIImage(named: "ringMask", in: bundle, compatibleWith: nil)
            ringMaskImageView.image = retrievedImage
        }
    }
    
    private func xibSetup() {
        contentView = UIView.fromNib(named: String(describing: ColorBubbleView.self),
                                     bundle: Bundle(for: self.classForCoder))!
        contentView!.frame = bounds
        
        contentView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView!)
    }
}
