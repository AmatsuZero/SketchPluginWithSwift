//
//  NativeConvertor.swift
//  SketchPlugin
//
//  Created by Jiang,Zhenhua on 2018/7/1.
//  Copyright © 2018年 Daubert. All rights reserved.
//

import AppKit

extension NSColor {
    convenience init?(mscolor: AnyObject) {
        guard let red = mscolor.value(forKeyPath: "red") as? CGFloat,
            let green = mscolor.value(forKeyPath: "green") as? CGFloat,
            let blue = mscolor.value(forKeyPath: "blue") as? CGFloat,
            let alpha = mscolor.value(forKeyPath: "alpha") as? CGFloat else {
            return nil
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
