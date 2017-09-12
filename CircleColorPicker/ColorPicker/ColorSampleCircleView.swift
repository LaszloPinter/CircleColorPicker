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
internal class ColorSampleCircleView: UIView {

    internal var ringWidth: CGFloat = 8.0 {
        didSet {
            resizeInnerCircle()
        }
    }
    
    internal var innerCircle: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInnerCircle()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInnerCircle()
        
    }
    
    func setupInnerCircle() {
        innerCircle = UIView()
        self.addSubview(innerCircle)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resizeInnerCircle()
        self.layer.cornerRadius = self.bounds.width * 0.5
    }
    /*override func willMove(toWindow newWindow: UIWindow?) {
        if newWindow != nil {
            self.layer.cornerRadius = fullRadius
            resizeInnerCircle()
        }
    }*/
 
    func setSampleColor(color: UIColor){
        innerCircle.backgroundColor = color
        self.backgroundColor = color.withAlphaComponent(0.5)
    }
    
    func resizeInnerCircle() {
    
        innerCircle.frame = innerCircleRect
        innerCircle.layer.cornerRadius = innerCircleRadius
    }
    
    private var fullRadius: CGFloat {
        get{
            let smaller = min(self.frame.size.width, self.frame.size.height)
            return smaller * 0.5
        }
    }
    
    private var innerCircleRadius: CGFloat {
        get{
            let smaller = min(self.frame.size.width, self.frame.size.height)
            return smaller * 0.5 - ringWidth
        }
    }
    
    private var innerCircleRect: CGRect {
        get{
            return  CGRect.init(origin: origo - CGVector(dx: innerCircleRadius, dy: innerCircleRadius), size: CGSize.init(width: innerCircleRadius * 2, height: innerCircleRadius * 2))
        }
       
    }
    
    private var origo: CGPoint {
        get{
            return CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        }
    }

}
