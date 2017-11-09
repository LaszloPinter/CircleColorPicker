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

extension SaturationPickerView {
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
        var shouldDragIt = true
        let satFrame = self.frame
        
        if point.x < satFrame.minX - bubbleDragRadius || point.x > satFrame.maxX + bubbleDragRadius {
            shouldDragIt = false
        }
        if point.y < satFrame.midY - bubbleDragRadius  || point.y > satFrame.midY + bubbleDragRadius {
            shouldDragIt = false
        }
        
        return shouldDragIt
    }
    
    private func onShouldMoveBubble(dragCoordinate: CGPoint) {
        let satFrame = self.frame
        
        if isVertical {
            let bubblePosition = calculateBubbleYPosition(forDragPosition: dragCoordinate)
            bubbleCenterY.constant = bubblePosition - satFrame.midY
        }else {
            let bubblePosition = calculateBubbleXPosition(forDragPosition: dragCoordinate)
            bubbleCenterX.constant = bubblePosition - satFrame.midX
        }

        UIView.animate(withDuration: animationTimeInSeconds, animations: {
            self.layoutIfNeeded()
            var percentage: CGFloat
            if self.isVertical {
               percentage = ((self.bubbleView.frame.midY - satFrame.midY) / satFrame.height) + 0.5
            }else {
               percentage = ((self.bubbleView.frame.midX - satFrame.midX) / satFrame.width) + 0.5
            }
            self.saturation = percentage
        })
    }
    
    private func calculateBubbleXPosition(forDragPosition: CGPoint) -> CGFloat {
        let satFrame = self.frame
        
        var bubblePosition = forDragPosition.x
        if bubblePosition < satFrame.minX {
            bubblePosition = satFrame.minX
        }else if bubblePosition > satFrame.maxX {
            bubblePosition = satFrame.maxX
        }
        
        return bubblePosition
    }
    
    private func calculateBubbleYPosition(forDragPosition: CGPoint) -> CGFloat {
        let satFrame = self.frame
        
        var bubblePosition = forDragPosition.y
        if bubblePosition < satFrame.minY {
            bubblePosition = satFrame.minY
        }else if bubblePosition > satFrame.maxY {
            bubblePosition = satFrame.maxY
        }
        
        return bubblePosition
    }
}
