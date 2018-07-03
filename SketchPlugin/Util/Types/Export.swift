//
//  Export.swift
//  SketchPlugin
//
//  Created by Jiang,Zhenhua on 2018/7/2.
//  Copyright © 2018年 Daubert. All rights reserved.
//

import Foundation

struct DJEXportFormat: DJSketchObjectProtocol {
    static var className: String {
        return "MSExportFormat"
    }
    var object: AnyObject?
    private var name: String? {
        return object?.value(forKeyPath: "name") as? String
    }
    var scale: CGFloat? {
        return object?.value(forKeyPath: "scale") as? CGFloat
    }
    var namingScheme: UInt64? {
        return object?.value(forKeyPath: "namingScheme") as? UInt64
    }
    var fileFormat: String? {
        return object?.value(forKeyPath: "fileFormat") as? String
    }
    private(set) var prefix: String?
    private(set) var suffix: String?
    
    init(_ msformat: AnyObject?) {
        self.object = msformat
        if namingScheme != nil {
            prefix = name
        } else {
            suffix = name
        }
    }
}


final class DJExportOptions: DJSketchObjectProtocol {
    static var className: String {
        return "MSImmutableModelObject"
    }
    var object: AnyObject?
    lazy var exportFormats: [DJEXportFormat] = {
        guard let array = object?.value(forKeyPath: "exportFormats") as? NSArray else { return [] }
        var temp = [DJEXportFormat]()
        for case let format as NSObject in array {
            temp += [DJEXportFormat(format)]
        }
        return temp
    }()
    var layerOptions: UInt64 {
        set(newValue) {
            object?.setValue(newValue, forKey: "layerOptions")
        }
        get {
            return object?.value(forKeyPath: "layerOptions") as! UInt64
        }
    }
    
    init(_ options: AnyObject?) {
        object = options
    }
}
