//
//  Extension.swift
//  DarkLight Wallpaper
//
//  Created by 严天龙 on 2024/12/9.
//

import AppKit

extension NSImage {
    func withRoundedCorners(radius: CGFloat) -> NSImage {
        let imageSize = self.size
        let newImage = NSImage(size: imageSize)
        
        newImage.lockFocus()
        let rect = NSRect(origin: .zero, size: imageSize)
        let path = NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
        path.addClip()
        
        self.draw(in: rect)
        newImage.unlockFocus()
        
        return newImage
    }
}


