//: Playground - noun: a place where people can play

import UIKit
// Determining the XTrans 

let y = [0.5,0,0.5,1]
let x = y[7 % 4]


// Unit -> HexNo converter 
let units = 4
let hexPerRow = 7

let unitNo = 4

let hexNo = (((unitNo - 1) / units) * 2 ) * hexPerRow + (unitNo % units) * 2 - 1


// Test colors 
var rate = 0.1


let maximumColor = UIColor.red
let minimumColor = UIColor.blue
let reverseColorMap = true



var startHue = CGFloat()
var startSat = CGFloat()
var startBri = CGFloat()
var startAlpha = CGFloat()

minimumColor.getHue(&startHue, saturation: &startSat, brightness: &startBri, alpha: &startAlpha)
print(startHue)

var endHue = CGFloat()
var endSat = CGFloat()
var endBri = CGFloat()
var endAlpha = CGFloat()
maximumColor.getHue(&endHue, saturation: &endSat, brightness: &endBri, alpha: &endAlpha)

if endHue == 1.0 && reverseColorMap == true {
    endHue = 0.0
}
print(endHue)


var h = startHue + ((endHue - startHue) * CGFloat(rate))
var s = startSat + ((endSat - startSat) * CGFloat(rate))
var b = startBri + ((endBri - startBri) * CGFloat(rate))

let finalColor = UIColor(hue: h, saturation: s, brightness: b, alpha: 1.0)
