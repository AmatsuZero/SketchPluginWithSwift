//
//  DJStyle.swift
//  SketchPlugin
//
//  Created by Jiang,Zhenhua on 2018/7/1.
//  Copyright © 2018年 Daubert. All rights reserved.
//

import AppKit

struct DJColorStop {
    let color: NSColor?
    let position: CGFloat?
    
    init(stop: AnyObject) {
        color = NSColor(mscolor: stop.value(forKeyPath: "color") as AnyObject)
        position = stop.value(forKeyPath: "postion") as? CGFloat
    }
}

struct DJGradient {
    
    enum GradientType: UInt64 {
        case linear = 0, radial, angular
    }
    
    let type: GradientType
    let from: CGPoint
    let to: CGPoint
    let colroStops: [DJColorStop]
    
    init?(msgradient: AnyObject) {
        guard let value = msgradient.value(forKeyPath: "gradientType") as? UInt64,
            let type = GradientType(rawValue: value),
            let from = msgradient.value(forKeyPath: "from") as? CGPoint,
            let to = msgradient.value(forKeyPath: "to") as? CGPoint else {
            return nil
        }
        self.type = type
        self.from = from
        self.to = to
        if let stops = msgradient.value(forKeyPath: "gradient") as? NSArray {
            var values = [DJColorStop]()
            for case let stop as AnyObject in stops {
                values.append(DJColorStop(stop: stop))
            }
            self.colroStops = values
        } else {
            self.colroStops = []
        }
    }
}

enum BasicFillType: UInt64 {
    case color = 0, gradient
}

struct DJBorder {
    
    enum BorderPosition: UInt64 {
        case center = 0, inside, outside
    }
    
    let postion: BorderPosition
    let fillType: BasicFillType
    let thickness: CGFloat
    let color: NSColor?
    let gradient: DJGradient?
    
    init?(msborder: AnyObject) {
        guard let thickness = msborder.value(forKeyPath: "thickness") as? CGFloat,
            let type = msborder.value(forKeyPath: "fillType") as? UInt64,
            let fillType = BasicFillType(rawValue: type),
            let p = msborder.value(forKeyPath: "position") as? UInt64,
            let postion = BorderPosition(rawValue: p) else {
                return nil
        }
        self.thickness = thickness
        self.fillType = fillType
        self.postion = postion
        switch fillType {
        case .color:
            self.color = NSColor(mscolor: msborder.value(forKeyPath: "color") as AnyObject)
            self.gradient = nil
        case .gradient:
            self.gradient = DJGradient(msgradient: msborder.value(forKeyPath: "gradient") as AnyObject)
            self.color = nil
        }
    }
}

struct DJFill {
    let fillType: BasicFillType
    let color: NSColor?
    let gradient: DJGradient?
    
    init?(msfill: AnyObject) {
        guard let type = msfill.value(forKeyPath: "fillType") as? UInt64,
            let fillType = BasicFillType(rawValue: type) else {
            return nil
        }
        self.fillType = fillType
        switch fillType {
        case .color:
            self.color = NSColor(mscolor: msfill.value(forKeyPath: "color") as AnyObject)
            self.gradient = nil
        case .gradient:
            self.gradient = DJGradient(msgradient: msfill.value(forKeyPath: "gradient") as AnyObject)
            self.color = nil
        }
    }
}

struct DJShadow {
    enum ShadowType: String {
        case outer = "outer"
        case inner = "inner"
    }
    let shadowType: ShadowType
    let offsetX: CGFloat
    let offsetY: CGFloat
    let blurRadius: CGFloat
    let spread: CGFloat
    
    init(msshadow: NSObject) {
        shadowType = type(of: msshadow).typeName == "MSStyleShadow" ? .outer : .inner
        offsetX = msshadow.value(forKeyPath: "offsetX") as? CGFloat ?? 0
        offsetY = msshadow.value(forKeyPath: "offsetY") as? CGFloat ?? 0
        blurRadius = msshadow.value(forKeyPath: "blurRadius") as? CGFloat ?? 0
        spread = msshadow.value(forKeyPath: "spread") as? CGFloat ?? 0
    }
}

final class DJStyle {
    private let style: NSObject
    lazy var borders: [DJBorder] = {
        guard let values = style.value(forKeyPath: "borders") as? NSArray else { return [] }
        var tmp = [DJBorder]()
        for case let border as AnyObject in values {
            if border.value(forKeyPath: "isEnabled") as? Bool == true,
                let b = DJBorder(msborder: border) {
                tmp.append(b)
            }
        }
        return tmp
    }()
    lazy var fiils: [DJFill] = {
        guard let values = style.value(forKeyPath: "fills") as? NSArray else { return [] }
        var tmp = [DJFill]()
        for case let border as AnyObject in values {
            if border.value(forKeyPath: "isEnabled") as? Bool == true,
                let b = DJFill(msfill: border) {
                tmp.append(b)
            }
        }
        return tmp
    }()
    lazy var shadows: [DJShadow] = {
        guard let values = style.value(forKeyPath: "shadows") as? NSArray else { return [] }
        var tmp = [DJShadow]()
        for case let shadow as NSObject in values {
            if shadow.value(forKeyPath: "isEnabled") as? Bool == true {
                let b = DJShadow(msshadow: shadow)
                tmp.append(b)
            }
        }
        return tmp
    }()
    lazy var innerShadows: [DJShadow] = {
        guard let values = style.value(forKeyPath: "shadows") as? NSArray else { return [] }
        var tmp = [DJShadow]()
        for case let shadow as NSObject in values {
            if shadow.value(forKeyPath: "isEnabled") as? Bool == true {
                let b = DJShadow(msshadow: shadow)
                tmp.append(b)
            }
        }
        return tmp
    }()
    var opacity: CGFloat {
        return style.value(forKeyPath: "contextSettings.opacity") as? CGFloat ?? 0
    }
    let sharedObjectID: String
    let className: String
    let name: String
    
    init(style: NSObject) {
        self.style = style
        sharedObjectID = style.value(forKeyPath: "sharedObjectID") as! String
        className = type(of: style).typeName
        name = style.value(forKeyPath: "name") as! String
    }
}
