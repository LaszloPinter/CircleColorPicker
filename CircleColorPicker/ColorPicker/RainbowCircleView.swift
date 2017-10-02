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

internal class RainbowCircleView: UIView {
    var rainbowRadius: CGFloat = 100.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var rainbowWidth: CGFloat = 8.0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    func drawRainbow(onContext context: CGContext){
        
        var huePath: UIBezierPath
        let sectors = 720
        let sectorAngle =  CGFloat(360 / CGFloat(sectors)).degreesToRadians()
        
        for  sectorNumber in  0 ... sectors{
            let currentAngle = (CGFloat(sectorNumber) * sectorAngle)
            huePath = UIBezierPath.init(arcCenter: origo, radius: rainbowRadius+20, startAngle: currentAngle, endAngle: currentAngle + sectorAngle*1.05, clockwise: true)
            huePath.addLine(to: origo)
            huePath.close()
            
            let color = UIColor.init(hue: getHue(at: currentAngle), saturation: 1, brightness: 1, alpha: 1).cgColor
            context.setFillColor(color)
            context.addPath(huePath.cgPath)
            context.fillPath()
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let circle = UIBezierPath(ovalIn: CGRect(x: origo.x - rainbowRadius, y: origo.y - rainbowRadius , width: rainbowRadius*2, height: rainbowRadius*2))
        let shapeCopyPath = circle.cgPath.copy(strokingWithWidth: rainbowWidth, lineCap: .butt, lineJoin: .bevel, miterLimit: 0)
        context.addPath(shapeCopyPath)
        
        context.clip(using: .winding)
        drawRainbow(onContext: context)
        context.resetClip()
    }
    
    var origo: CGPoint {
        get{
            return CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        }
    }
    
    func getHue(at radians: CGFloat) -> CGFloat {
        return ((radians.radiansToDegrees()+360).truncatingRemainder(dividingBy: 360))/360
    }
}

