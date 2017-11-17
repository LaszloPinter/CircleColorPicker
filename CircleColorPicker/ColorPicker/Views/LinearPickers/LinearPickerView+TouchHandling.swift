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

import Foundation

extension LinearPickerView {
    private var bubbleDragRadius: CGFloat {
        get{
            return bubbleSize * 0.5 + 4
        }
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        
        let coordinate = touch.location(in: self)
        if shouldDragBubble(at: coordinate) {
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
    
    private func shouldDragBubble(at point: CGPoint) -> Bool{
        return hitTest(point, with: nil) != nil
    }
    
    private func onShouldMoveBubble(dragCoordinate: CGPoint) {
        let bounds = self.bounds
        
        if isVertical {
            let bubblePosition = calculateBubbleYPosition(forDragPosition: dragCoordinate)
            bubbleCenterY.constant = bubblePosition - bounds.midY
        }else {
            let bubblePosition = calculateBubbleXPosition(forDragPosition: dragCoordinate)
            bubbleCenterX.constant = bubblePosition - bounds.midX
        }

        UIView.animate(withDuration: animationTimeInSeconds, animations: {
            self.layoutIfNeeded()
            var percentage: CGFloat
            if self.isVertical {
               percentage = (-(self.bubbleView.frame.midY - bounds.midY) / bounds.height) + 0.5
            }else {
               percentage = ((self.bubbleView.frame.midX - bounds.midX) / bounds.width) + 0.5
            }
            self.storedValue = percentage
            self.onValueChange?(self.storedValue)
        })
    }
    
    private func calculateBubbleXPosition(forDragPosition: CGPoint) -> CGFloat {
        let bounds = self.bounds
        
        var bubblePosition = forDragPosition.x
        if bubblePosition < bounds.minX {
            bubblePosition = bounds.minX
        }else if bubblePosition > bounds.maxX {
            bubblePosition = bounds.maxX
        }
        
        return bubblePosition
    }
    
    private func calculateBubbleYPosition(forDragPosition: CGPoint) -> CGFloat {
        let bounds = self.bounds
        
        var bubblePosition = forDragPosition.y
        if bubblePosition < bounds.minY {
            bubblePosition = bounds.minY
        }else if bubblePosition > bounds.maxY {
            bubblePosition = bounds.maxY
        }
        
        return bubblePosition
    }
    
    override open func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if isHidden || alpha == 0 {
            return nil
        }
        
        let frame = self.bounds
        let range = bubbleWidth.constant * 0.5
        let rect = CGRect(x: frame.minX-range  , y: frame.minY-range, width: frame.width+range*2, height: frame.height+range*2)
        
        if rect.contains(point) {
            return self
        }
        return nil
    }
    
}
