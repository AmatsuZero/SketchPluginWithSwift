//
//  index.swift
//  SketchPlugin
//
//  Created by Jiang,Zhenhua on 2018/6/30.
//  Copyright © 2018年 Daubert. All rights reserved.
//

import Foundation

class DJSketchPlugin {
    let context: NSDictionary
    let version: String
    let rootURL: URL
    private(set) var parser: DJSketchParser!
    
    static private(set) var shared: DJSketchPlugin!
    
    @objc init(context: NSDictionary) {
        self.context = context
        version = context.value(forKeyPath: "plugin.version") as! String
        #if DEBUG
            let path = context.value(forKeyPath: "scriptPath") as! String
            rootURL = URL(fileURLWithPath: path).deletingLastPathComponent()
        #else
            let path = context.value(forKey: "plugin.url") as! URL
            rootURL = path.appendPathComponent("Contents/Sketch")
        #endif
    }
}
