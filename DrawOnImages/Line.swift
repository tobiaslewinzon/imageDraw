//
//  Line.swift
//  DrawOnImages
//
//  Created by Tobias Lewinzon on 17/07/2020.
//  Copyright © 2020 tobiaslewinzon. All rights reserved.
//

import UIKit

struct Line {
    let color: CGColor
    var points: [CGPoint]
    
    init(color: UIColor, points: [CGPoint]) {
        self.color = color.cgColor
        self.points = points
    }
}
