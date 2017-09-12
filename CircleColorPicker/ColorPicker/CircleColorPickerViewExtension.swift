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
        }else if shouldDragKnob(at: coordinate) {
            isKnobDragged = true
            onShouldMoveKnob(dragCoordinate: coordinate)
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        let coordinate = touch.location(in: self)
        
        if isBubbleDragged {
            onShouldMoveBubble(dragCoordinate: coordinate)
        }else if isKnobDragged {
            onShouldMoveKnob(dragCoordinate: coordinate)
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.first != nil else{
            return
        }
        
        isBubbleDragged = false
        isKnobDragged = false
    }
    
    private func onShouldMoveKnob(dragCoordinate: CGPoint) {
        let satFrame = saturationPickerView.frame
        
        let knobPosition = calculateKnobPosition(forDragPosition: dragCoordinate)

        saturationKnobPosition.constant = knobPosition - satFrame.midX
        
        UIView.animate(withDuration: animationTimeInSeconds, animations: {
            self.layoutIfNeeded()
            let percentage = ((self.saturationKnob.frame.midX - satFrame.midX) / satFrame.width) + 0.5
            self.saturation = percentage
        })
    }
    
    private func onShouldMoveBubble(dragCoordinate: CGPoint) {
        let dragAngle = CGVector(point: dragCoordinate - origo).angle
        
        UIView.animate(withDuration: animationTimeInSeconds, animations: {
            self.colorBubbleView.transform = CGAffineTransform(rotationAngle: dragAngle)
            let currentRads:CGFloat = CGFloat(atan2f(Float(self.colorBubbleView.transform.b), Float(self.colorBubbleView.transform.a)))
            self.hue = self.rainbowCircleView.getHue(at: currentRads)
        })
    }
    
    private func shouldDragKnob(at point: CGPoint) -> Bool{
        var shouldDragIt = true
        let satFrame = saturationPickerView.frame
        
        if point.x < satFrame.minX - knobDragRadius || point.x > satFrame.maxX + knobDragRadius {
            shouldDragIt = false
        }
        if point.y < satFrame.midY - knobDragRadius  || point.y > satFrame.midY + knobDragRadius {
            shouldDragIt = false
        }
        
        return shouldDragIt
    }
    
    private var knobDragRadius: CGFloat {
        get{
            return satKnobSize * 0.5 + 4
        }
    }
    
    private func calculateKnobPosition(forDragPosition: CGPoint) -> CGFloat {
        let satFrame = saturationPickerView.frame
        
        var knobPosition = forDragPosition.x
        if knobPosition < satFrame.minX {
            knobPosition = satFrame.minX
        }else if knobPosition > satFrame.maxX {
            knobPosition = satFrame.maxX
        }
        
        return knobPosition
    }
}
