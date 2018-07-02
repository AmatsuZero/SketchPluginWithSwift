//
//  StyleContainer.swift
//  SketchPlugin
//
//  Created by Jiang,Zhenhua on 2018/7/2.
//  Copyright © 2018年 Daubert. All rights reserved.
//

import Foundation

final class DJSharedTextStyleContainer {
    
}

final class DJSharedStyle {
    let style: DJStyle
    internal let msstyle: NSObject
    
    init(_ sharedStyle: NSObject) {
        msstyle = sharedStyle
        style = DJStyle(sharedStyle.value(forKeyPath: "style") as! NSObject)
    }
    init(name: String, style: DJStyle) {
        self.style = style
        let clazz = NSClassFromString("MSSharedStyle") as AnyObject as! NSObjectProtocol
        let uninitializedObj = clazz.perform(NSSelectorFromString("alloc"))?.takeUnretainedValue()
        let selector = NSSelectorFromString("initWithName:firstInstance:")
        msstyle = uninitializedObj?.perform(selector,
                                            with: name,
                                            with: style.style).takeUnretainedValue() as! NSObject
    }
}
