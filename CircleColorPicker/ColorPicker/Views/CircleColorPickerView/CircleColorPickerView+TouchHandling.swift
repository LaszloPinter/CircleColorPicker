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

extension CircleColorPickerView { //Touch handling
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        
        let coordinate = touch.location(in: self)
        if abs(coordinate.distanceTo(self.origo) - rainbowRadius) <  bubbleRadius + rainbowWidth {
            isBubbleDragged = true
            onShouldMoveBubble(dragCoordinate: coordinate)
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        let coordinate = touch.location(in: self)
        
        if isBubbleDragged {
            onShouldMoveBubble(dragCoordinate: coordinate)
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.first != nil else{
            return
        }
        
        isBubbleDragged = false
    }
    
    private func onShouldMoveBubble(dragCoordinate: CGPoint) {
        let dragAngle = CGVector(point: dragCoordinate - origo).angle
        
        UIView.animate(withDuration: animationTimeInSeconds, animations: {
            self.colorBubbleView.transform = CGAffineTransform(rotationAngle: dragAngle)
            let currentRads:CGFloat = CGFloat(atan2f(Float(self.colorBubbleView.transform.b), Float(self.colorBubbleView.transform.a)))
            self.hue = self.rainbowCircleView.getHue(at: currentRads)
        })
    }
    

}
