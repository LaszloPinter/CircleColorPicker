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
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    func setBubbleColor(color: UIColor){
        bubbleBackgroundView.backgroundColor = color
        connectStringView.backgroundColor = color.withAlphaComponent(0.5)
    }
    
    private func xibSetup() {
        contentView = loadViewFromNib()
        contentView!.frame = bounds
        
        contentView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView!)
    }
    
    private func loadViewFromNib() -> UIView! {
        let bundle = Bundle(for: ColorBubbleView.self)
        let nib = UINib(nibName: String(describing: ColorBubbleView.self), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }
}
