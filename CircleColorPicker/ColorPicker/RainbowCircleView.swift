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
    var rainbowImage: CGImage!
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rainbowImage = drawColorCircleImage(withDiameter: Int(min(self.bounds.size.width, self.bounds.size.height)))
    }
    
    func drawColorCircleImage(withDiameter diameter: Int) -> CGImage {
        let bufferLength: Int = Int(diameter * diameter * 4)
        
        let bitmapData: CFMutableData = CFDataCreateMutable(nil, 0)
        CFDataSetLength(bitmapData, CFIndex(bufferLength))
        let bitmap = CFDataGetMutableBytePtr(bitmapData)
        
        for y in 0 ... diameter {
            for x in 0 ... diameter {
                let angle = CGVector(point: CGPoint(x: x, y: diameter-y) - origo).angle
                let rgbComponents = UIColor.init(hue: getHue(at: angle), saturation: 1, brightness: 1, alpha: 1).cgColor.components!
                
                let offset = Int(4 * (x + y * diameter))
                bitmap?[offset] = UInt8(rgbComponents[0]*255)
                bitmap?[offset + 1] = UInt8(rgbComponents[1]*255)
                bitmap?[offset + 2] = UInt8(rgbComponents[2]*255)
                bitmap?[offset + 3] = UInt8(255)
            }
        }
        
        let colorSpace: CGColorSpace? = CGColorSpaceCreateDeviceRGB()
        let dataProvider: CGDataProvider? = CGDataProvider(data: bitmapData)
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.last.rawValue)
        let imageRef: CGImage? = CGImage(width: diameter, height: diameter, bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: diameter * 4, space: colorSpace!, bitmapInfo: bitmapInfo, provider: dataProvider!, decode: nil, shouldInterpolate: false, intent: CGColorRenderingIntent.defaultIntent)
        return imageRef!
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
        context.draw(rainbowImage, in: self.bounds)
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

