#!/usr/bin/swift

import AppKit

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let iconset = root.appendingPathComponent("Stats/Supporting Files/Assets.xcassets/AppIcon.appiconset")

let outputs: [(String, CGFloat)] = [
    ("icon_16x16.png", 16),
    ("icon_16x16@2x.png", 32),
    ("icon_32x32.png", 32),
    ("icon_32x32@2x.png", 64),
    ("icon_128x128.png", 128),
    ("icon_256x256 1.png", 256),
    ("icon_256x256.png", 256),
    ("icon_512x512 1.png", 512),
    ("icon_512x512.png", 512),
    ("icon_512x512@2x.png", 1024)
]

func roundedRect(_ rect: CGRect, radius: CGFloat) -> NSBezierPath {
    NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius)
}

func drawIcon(size: CGFloat) -> NSBitmapImageRep {
    let pixels = Int(size)
    guard let bitmap = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: pixels,
        pixelsHigh: pixels,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .deviceRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    ) else {
        fatalError("failed to create bitmap context")
    }
    
    bitmap.size = NSSize(width: size, height: size)
    NSGraphicsContext.saveGraphicsState()
    guard let graphicsContext = NSGraphicsContext(bitmapImageRep: bitmap) else {
        fatalError("failed to create graphics context")
    }
    NSGraphicsContext.current = graphicsContext
    defer {
        NSGraphicsContext.restoreGraphicsState()
    }
    
    let context = graphicsContext.cgContext
    
    let rect = CGRect(x: 0, y: 0, width: size, height: size)
    let inset = size * 0.06
    let card = rect.insetBy(dx: inset, dy: inset)
    let corner = size * 0.22
    
    context.setAllowsAntialiasing(true)
    context.setShouldAntialias(true)
    
    let shadow = NSShadow()
    shadow.shadowOffset = NSSize(width: 0, height: -size * 0.012)
    shadow.shadowBlurRadius = size * 0.04
    shadow.shadowColor = NSColor(calibratedWhite: 0, alpha: 0.28)
    shadow.set()
    
    NSGraphicsContext.saveGraphicsState()
    let cardPath = roundedRect(card, radius: corner)
    cardPath.addClip()
    
    let bg = NSGradient(colors: [
        NSColor(calibratedRed: 0.05, green: 0.10, blue: 0.16, alpha: 1),
        NSColor(calibratedRed: 0.08, green: 0.18, blue: 0.24, alpha: 1),
        NSColor(calibratedRed: 0.06, green: 0.14, blue: 0.21, alpha: 1)
    ])!
    bg.draw(in: cardPath, angle: 90)
    
    let glowRect = CGRect(x: card.minX, y: card.midY, width: card.width, height: card.height * 0.7)
    let glow = NSGradient(colors: [
        NSColor(calibratedRed: 0.04, green: 0.80, blue: 0.78, alpha: 0.00),
        NSColor(calibratedRed: 0.04, green: 0.80, blue: 0.78, alpha: 0.18)
    ])!
    glow.draw(in: glowRect, angle: -90)
    NSGraphicsContext.restoreGraphicsState()
    
    NSColor(calibratedWhite: 1, alpha: 0.12).setStroke()
    cardPath.lineWidth = max(2, size * 0.008)
    cardPath.stroke()
    
    let monitorRect = CGRect(
        x: card.minX + card.width * 0.15,
        y: card.minY + card.height * 0.28,
        width: card.width * 0.62,
        height: card.height * 0.43
    )
    let monitorPath = roundedRect(monitorRect, radius: size * 0.07)
    NSColor(calibratedWhite: 1, alpha: 0.94).setFill()
    monitorPath.fill()
    
    let innerRect = monitorRect.insetBy(dx: size * 0.026, dy: size * 0.026)
    let innerPath = roundedRect(innerRect, radius: size * 0.045)
    NSColor(calibratedRed: 0.03, green: 0.08, blue: 0.13, alpha: 1).setFill()
    innerPath.fill()
    
    let standNeck = roundedRect(
        CGRect(
            x: monitorRect.midX - size * 0.035,
            y: monitorRect.minY - size * 0.085,
            width: size * 0.07,
            height: size * 0.10
        ),
        radius: size * 0.022
    )
    NSColor(calibratedWhite: 1, alpha: 0.88).setFill()
    standNeck.fill()
    
    let standBase = roundedRect(
        CGRect(
            x: monitorRect.midX - size * 0.13,
            y: monitorRect.minY - size * 0.125,
            width: size * 0.26,
            height: size * 0.045
        ),
        radius: size * 0.022
    )
    standBase.fill()
    
    let gridColor = NSColor(calibratedRed: 0.25, green: 0.72, blue: 0.82, alpha: 0.20)
    gridColor.setStroke()
    for idx in 1...3 {
        let x = innerRect.minX + innerRect.width * CGFloat(idx) / 4
        let y = innerRect.minY + innerRect.height * CGFloat(idx) / 4
        let vertical = NSBezierPath()
        vertical.move(to: CGPoint(x: x, y: innerRect.minY + size * 0.02))
        vertical.line(to: CGPoint(x: x, y: innerRect.maxY - size * 0.02))
        vertical.lineWidth = max(1, size * 0.004)
        vertical.stroke()
        
        let horizontal = NSBezierPath()
        horizontal.move(to: CGPoint(x: innerRect.minX + size * 0.02, y: y))
        horizontal.line(to: CGPoint(x: innerRect.maxX - size * 0.02, y: y))
        horizontal.lineWidth = max(1, size * 0.004)
        horizontal.stroke()
    }
    
    let line = NSBezierPath()
    let points: [CGPoint] = [
        CGPoint(x: innerRect.minX + innerRect.width * 0.06, y: innerRect.minY + innerRect.height * 0.34),
        CGPoint(x: innerRect.minX + innerRect.width * 0.18, y: innerRect.minY + innerRect.height * 0.38),
        CGPoint(x: innerRect.minX + innerRect.width * 0.30, y: innerRect.minY + innerRect.height * 0.22),
        CGPoint(x: innerRect.minX + innerRect.width * 0.44, y: innerRect.minY + innerRect.height * 0.62),
        CGPoint(x: innerRect.minX + innerRect.width * 0.58, y: innerRect.minY + innerRect.height * 0.48),
        CGPoint(x: innerRect.minX + innerRect.width * 0.72, y: innerRect.minY + innerRect.height * 0.74),
        CGPoint(x: innerRect.minX + innerRect.width * 0.90, y: innerRect.minY + innerRect.height * 0.58)
    ]
    if let first = points.first {
        line.move(to: first)
        for point in points.dropFirst() {
            line.line(to: point)
        }
    }
    NSColor(calibratedRed: 0.19, green: 0.97, blue: 0.78, alpha: 1).setStroke()
    line.lineWidth = max(3, size * 0.018)
    line.lineCapStyle = .round
    line.lineJoinStyle = .round
    line.stroke()
    
    for point in points.dropFirst().dropLast() {
        let dot = NSBezierPath(ovalIn: CGRect(x: point.x - size * 0.016, y: point.y - size * 0.016, width: size * 0.032, height: size * 0.032))
        NSColor(calibratedRed: 0.55, green: 1.0, blue: 0.90, alpha: 1).setFill()
        dot.fill()
    }
    
    let railX = card.maxX - card.width * 0.18
    let railTop = card.minY + card.height * 0.26
    let railBottom = card.maxY - card.height * 0.20
    let rail = NSBezierPath()
    rail.move(to: CGPoint(x: railX, y: railTop))
    rail.line(to: CGPoint(x: railX, y: railBottom))
    NSColor(calibratedWhite: 1, alpha: 0.16).setStroke()
    rail.lineWidth = max(2, size * 0.008)
    rail.stroke()
    
    let barWidths = [0.16, 0.28, 0.43, 0.62]
    let barHeights = [0.10, 0.18, 0.28, 0.40]
    for idx in 0..<barWidths.count {
        let width = card.width * 0.11
        let height = card.height * barHeights[idx]
        let x = railX - width / 2
        let y = railTop + card.height * barWidths[idx]
        let bar = roundedRect(CGRect(x: x, y: y, width: width, height: height), radius: size * 0.018)
        NSColor(calibratedRed: 0.20, green: 0.62 + CGFloat(idx) * 0.08, blue: 0.92, alpha: 0.95).setFill()
        bar.fill()
    }
    
    let pulse = NSBezierPath(ovalIn: CGRect(
        x: card.minX + card.width * 0.13,
        y: card.maxY - card.height * 0.18,
        width: size * 0.09,
        height: size * 0.09
    ))
    NSColor(calibratedRed: 1.0, green: 0.34, blue: 0.34, alpha: 0.95).setFill()
    pulse.fill()
    
    return bitmap
}

for (filename, size) in outputs {
    let rep = drawIcon(size: size)
    guard
        let png = rep.representation(using: .png, properties: [:])
    else {
        fputs("failed to generate \(filename)\n", stderr)
        exit(1)
    }
    
    try png.write(to: iconset.appendingPathComponent(filename))
    print("wrote \(filename)")
}
