//
//  SOMChart.swift
//  SOM_Chart
//
//  Created by Behrad Bagheri on 7/20/16.
//  Updated on 08/13/2018 -> Swift 4.0 
//
//

import UIKit


@IBDesignable

class SOMChart : UIView {
    let π:CGFloat = CGFloat(Double.pi)
    
    @IBInspectable var units : Int = 4
    @IBInspectable var hitUnit : Int = 0 {
        didSet {
            if hitUnit > units * units {
                hitUnit = units * units
            }
            if (hitUnit < 0) {
                hitUnit = 0
            }
            setNeedsDisplay()
            
        }
    }
    
    @IBInspectable var hitColor : UIColor = UIColor.green
    @IBInspectable var unitBorderColor : UIColor = UIColor.white
    @IBInspectable var unitBorderWidth : CGFloat = 1.0
    
    @IBInspectable var minimumColor : UIColor = UIColor.blue
    @IBInspectable var maximumColor : UIColor = UIColor.red
    @IBInspectable var reverseColorMap : Bool = true
    
    
    var distanceMatrix : [Double]? {
        didSet {
            if (distanceMatrix != nil) {
                let n = Double((distanceMatrix?.count)!)
                let n2 = (sqrt(n) + 1) / 2
                units = Int(n2)
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        
        
        let context = UIGraphicsGetCurrentContext()
        
        let hexPerRow = units + (units - 1)
        let nHex = pow(Double(hexPerRow), 2)
        
        
        
        
        let spaceAvailable = min(rect.width, rect.height)
        
        
        let hexHeight = spaceAvailable / CGFloat(hexPerRow)
        let hexWidth = sin(π/3) * hexHeight
    
        
        //1 - save original state
        context!.saveGState()
        
        //2 - Create our hexagon
        let hexPath = UIBezierPath()
        
        hexPath.move(to: CGPoint(x:hexWidth/2,
            y:0))
        hexPath.addLine(to: CGPoint(x: hexWidth, y: hexHeight / 4))
        hexPath.addLine(to: CGPoint(x: hexWidth, y: 3 * hexHeight / 4))
        hexPath.addLine(to: CGPoint(x: hexWidth / 2, y: hexHeight))
        hexPath.addLine(to: CGPoint(x: 0, y: 3 * hexHeight / 4))
        hexPath.addLine(to: CGPoint(x: 0, y: hexHeight / 4))
        hexPath.close()
        
        
        var hexNo = 0.0
        var unitNo = 0
        let colorStep = 1.0 / nHex
        let xTrans = [hexWidth / 2, 0, hexWidth / 2, hexWidth]
        
        
        let x_inset = (rect.width - hexWidth * CGFloat(hexPerRow + 1)) / 2
        let y_inset = (rect.height - (hexHeight * CGFloat(hexPerRow - 1) * 3 / 4 ) - hexHeight ) / 2
        
        for ii in 1...hexPerRow {
            
            for jj in 1...hexPerRow {
                
                
                
                
                context!.saveGState()
                
                
                // Determine if current hex is a unit and if it has been hit
                
                hexNo += 1.0
                var isUnit = false
                var isHit = false
                if (ii % 2) == 1 && (jj % 2) == 1 {
                    unitNo += 1
                    isUnit = true
                    if unitNo == hitUnit {
                        isHit = true
                    }
                }
                
                // Transform Context to place Hex in correct place 
                
                let transX = x_inset + (CGFloat(ii-1) * hexWidth) + xTrans[jj % 4]
                let transY = y_inset + CGFloat(jj-1) * hexHeight * 3 / 4
                
                
                context!.translateBy(x: transX,
                                      y: transY)

                
                // Set Fill Color
                var faceColor = UIColor()

                if distanceMatrix == nil {
                    faceColor = UIColor(red: CGFloat(hexNo * colorStep), green: 0.2, blue: 0.2, alpha: 1.0)
                } else {
                    faceColor = hexColorFromDistance(Int(hexNo))
                }
                
                if (isHit) {
                    faceColor = hitColor
                }
                
                faceColor.setFill()
                hexPath.fill()
                
                
                // set border if required
                if isUnit {
                    let borderColor = unitBorderColor
                    borderColor.setStroke()
                    hexPath.lineWidth = unitBorderWidth
                    hexPath.stroke()
                }
                
                
                
                context!.restoreGState()
            }
        }
        
        //8 - restore the original state in case of more painting
        context!.restoreGState()
        
        
    }
    
    func hexColorFromDistance (_ hexNo: Int) -> UIColor {
        
        var hexColor = UIColor()
        
        
        let rate = distanceMatrix![hexNo - 1] / (distanceMatrix?.max())!
        
        var startHue = CGFloat()
        var startSat = CGFloat()
        var startBri = CGFloat()
        var startAlpha = CGFloat()
        
        minimumColor.getHue(&startHue, saturation: &startSat, brightness: &startBri, alpha: &startAlpha)
        
        var endHue = CGFloat()
        var endSat = CGFloat()
        var endBri = CGFloat()
        var endAlpha = CGFloat()
        maximumColor.getHue(&endHue, saturation: &endSat, brightness: &endBri, alpha: &endAlpha)
        
        
        if endHue == 1.0 && reverseColorMap == true {
            endHue = 0.0
        }
        
        
        
        let h = startHue + ((endHue - startHue) * CGFloat(rate))
        let s = startSat + ((endSat - startSat) * CGFloat(rate))
        let b = startBri + ((endBri - startBri) * CGFloat(rate))
        
        hexColor = UIColor(hue: h, saturation: s, brightness: b, alpha: 1.0)
        
        
        return hexColor
        
    }
    
    
}
