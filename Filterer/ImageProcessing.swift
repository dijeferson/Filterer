//
//  ImageProcessing.swift
//  Filterer
//
//  Created by Jeferson Santos on 14/04/16.
//  Copyright © 2016 Jeferson Santos. All rights reserved.
//

import Foundation
import UIKit

class ImageProcessing {
    func makeBright(_ image: UIImage, amount: Int = 20) -> UIImage {
        return process(image, amount: amount, filter: "brightness")
    }
    
    func makeWarm(_ image: UIImage, amount: Int = 15) -> UIImage {
        return process(image, amount: amount, filter: "warm")
    }
    
    func makeCold(_ image: UIImage, amount: Int = 15) -> UIImage {
        return process(image, amount: amount, filter: "cold")
    }
    
    func makePoster(_ image: UIImage, amount: Int = 10) -> UIImage {
        return process(image, amount: amount, filter: "poster")
    }
    
    func makeColor(_ image: UIImage, amount: Int = 10) -> UIImage {
        return process(image, amount: amount, filter: "colorize")
    }
    
    func batch(_ image: UIImage, filters: [String]) -> UIImage {
        var resultImage: UIImage = image
        
        for filter in filters {
            
            switch filter {
            case "doublebrightness":
                resultImage = process(resultImage, amount: 128, filter: "brightness")
                break
            case "halfbrightness":
                resultImage = process(resultImage, amount: 128, filter: "darkness")
                break
            case "colder":
                resultImage = process(resultImage, amount: 64, filter: "cold")
                break
            case "warmer":
                resultImage = process(resultImage, amount: 64, filter: "warm")
                break
            case "colorful":
                resultImage = process(resultImage, amount: 32, filter: "color")
                break
            case "posterize":
                resultImage = process(resultImage, amount: 128, filter: "poster")
                break
            default:
                print("\(filter) is not a valid predefined filter.")
                break
            }
            
        }
        
        return resultImage
    }
    
    func process(_ image: UIImage, amount: Int, filter: String) -> UIImage {
        var rgba = RGBAImage(image: image)!
        var index = 0
        
        for p in rgba.pixels {
            rgba.pixels[index] = processPixel(filter, amount: amount, pixel: p)
            index += 1
        }
        
        return rgba.toUIImage()!
    }
    
    fileprivate func processPixel(_ filter: String, amount: Int, pixel: Pixel) -> Pixel {
        var affectedPixel: Pixel = pixel
        var red = Int(pixel.red)
        var blue = Int(pixel.blue)
        var green = Int(pixel.green)
        
        switch filter {
        case "brightness":
            red += amount
            blue += amount
            green += amount
        case "darkness":
            red -= amount
            blue -= amount
            green -= amount
        case "colorize":
            red = blue + (amount / 8)
            blue = green + (amount / 8)
            green = blue + (amount / 8)
        case "warm":
            red += amount
            blue += amount / 8
            green += amount / 8
        case "cold":
            red += amount / 8
            blue += amount
            green += amount / 8
        case "poster":
            red += amount / 32
            blue += amount / 32
            green += amount / 32
            
            if(red >= 0 && red < 64) { red = 32}
            if(red >= 64 && red < 128) { red = 96}
            if(red >= 128 && red < 256) { red = 192}
            
            if(blue >= 0 && blue < 64) { blue = 32}
            if(blue >= 64 && blue < 128) { blue = 96}
            if(blue >= 128 && blue < 256) { blue = 192}
            
            if(green >= 0 && green < 64) { green = 32}
            if(green >= 64 && green < 128) { green = 96}
            if(green >= 128 && green < 256) { green = 192}
        default:
            return affectedPixel
        }
        
        affectedPixel.red = UInt8(max(0, min(255, red)))
        affectedPixel.blue = UInt8(max(0, min(255, blue)))
        affectedPixel.green = UInt8(max(0, min(255, green)))
        
        return affectedPixel
    }
}
