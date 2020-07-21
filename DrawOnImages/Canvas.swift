//
//  Canvas.swift
//  DrawOnImages
//
//  Created by Tobias Lewinzon on 17/07/2020.
//  Copyright © 2020 tobiaslewinzon. All rights reserved.
//

import UIKit

class Canvas: UIView {
    
    // MARK: Global properties
    var lines = [Line]()
    
    var color = UIColor.white
    
    // MARK: - Drawing
    // 1- When user taps on screen, create an empty Line and append it to our lines array. This will initiate a new line instance to which we add points as the user drags on the method below.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(Line(color: color, points: []))
    }
    
    // 2- Called when user drags through screen.
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Guard the current point.
        guard let point = touches.first?.location(in: nil) else { return }
        
        // Get and remove the last line of the lines array (current), and append the new point to it.
        // We always work on the latest line added to allow continuity.
        guard var lastLine = lines.popLast() else { return }
        
        // Add point to this line.
        lastLine.points.append(point)
        
        // Re-add updated line to lines array to be drawn.
        lines.append(lastLine)
        
        // Calling this method informs the view that its elements need to be redrawn. By calling it inside this method, the user can experience the drawing live.
        setNeedsDisplay()
    }
    
    // 3- Time to draw.
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // Iterating through lines.
        lines.forEach { (line) in
            // Configure line.
            context.setLineWidth(5)
            context.setLineCap(.round)
            context.setStrokeColor(line.color)
            
            // Iterating through points.
            for (index, point) in line.points.enumerated() {
                // For the first point, place the context to begin line.
                // For the rest of the points, add a line connecting to current point.
                _ = index == 0 ? context.move(to: point) : context.addLine(to: point)
            }
            
            // Actually paints the lines.
            context.strokePath()
        }
    }
    
    // MARK: - Action methods
    
    /// Removes latest line.
    func undo() {
        _ = lines.popLast()
        setNeedsDisplay()
    }
    
    /// Clears all lines.
    func clear() {
        lines.removeAll()
        setNeedsDisplay()
    }
    
    /// Updates color
    func changeColor(to color: UIColor) {
        self.color = color
    }
}
