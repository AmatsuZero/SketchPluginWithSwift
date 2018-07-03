//
//  InvocationHelper.swift
//  SketchPlugin
//
//  Created by Jiang,Zhenhua on 2018/6/30.
//  Copyright © 2018年 Daubert. All rights reserved.
//

import AppKit

class DJSketchPluginHelper {
    
    private static let allocMethod = NSSelectorFromString("alloc")
    
    class func convientInitializer(className: NSObjectProtocol,
                             initSelector: String = "init",
                             with obj: Any? = nil) -> AnyObject? {
        let uninitializedObj = className.perform(allocMethod)?.takeUnretainedValue()
        let selector = NSSelectorFromString(initSelector)
        return uninitializedObj?.perform(selector, with: obj)?.takeUnretainedValue()
    }
}

extension NSObject {
    func toNSColor(mscolor: NSObject, colorSpace: NSColorSpace) -> NSColor? {
        let selector = NSSelectorFromString("NSColorWithColorSpace:")
        return mscolor.perform(selector, with: colorSpace).takeUnretainedValue() as? NSColor
    }
}

