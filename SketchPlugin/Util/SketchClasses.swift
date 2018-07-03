//
//  SketchClasses.swift
//  SketchPlugin
//
//  Created by Jiang,Zhenhua on 2018/6/30.
//  Copyright © 2018年 Daubert. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol DJSketchObjectProtocol {
    static var className: String { get }
    var object: AnyObject? { set get }
    func new(selector: String, with: Any?) -> AnyObject?
}

extension DJSketchObjectProtocol {
    func new(selector: String = "init", with: Any? = nil) -> AnyObject? {
        let clazz = NSClassFromString(Self.className) as AnyObject
        let cls = clazz as! NSObjectProtocol
        return DJSketchPluginHelper.convientInitializer(className: cls, initSelector: selector, with: with)
    }
}

//MARK: Layer
final class DJLayerGroup: DJSketchObjectProtocol {
    static var className: String {
        return "MSLayerGroup"
    }
    lazy var object: AnyObject? = {
        return new()
    }()
}

final class DJShapeGroup: DJSketchObjectProtocol {
    static var className: String { return "MSShapeGroup" }
    var object: AnyObject?
    init(rect: NSRect = .init(x: 0, y: 0, width: 100, height: 100), shape: DJRectangleShape) {
        let clazz = NSClassFromString(DJShapeGroup.className) as AnyObject
        let cls = clazz as! NSObjectProtocol
        let selector = NSSelectorFromString("shapeWithPath:")
        object = cls.perform(selector, with: shape.object)?.takeUnretainedValue()
    }
}

final class DJTextLayer: DJSketchObjectProtocol {
    enum TextAlignment: UInt64 {
        case left = 0, right, center, justify
    }
    static var className: String {
        return "MSLayerGroup"
    }
    var text: String? {
        set(newValue) {
            object?.setValue(newValue, forKeyPath: "stringValue")
        }
        get {
            return object?.value(forKeyPath: "stringValue") as? String
        }
    }
    var alignment: TextAlignment? {
        set(newValue) {
            object?.setValue(newValue?.rawValue, forKeyPath: "textAlignment")
        }
        get {
            let rawValue = object?.value(forKeyPath: "textAlignment") as! UInt64
            return TextAlignment(rawValue: rawValue)
        }
    }
    var fontSize: CGFloat {
        set(newValue) {
            object?.setValue(newValue, forKeyPath: "fontSize")
        }
        get {
            return object?.value(forKeyPath: "fontSize") as! CGFloat
        }
    }
    var fontPostscriptName: String? {
        set(newValue) {
            object?.setValue(newValue, forKeyPath: "fontPostscriptName")
        }
        get {
            return object?.value(forKeyPath: "fontPostscriptName") as? String
        }
    }
    lazy var object: AnyObject? = {
        return new()
    }()
    var lineHeight: CGFloat {
        set(newValue) {
            object?.setValue(newValue, forKey: "lineHeight")
        }
        get {
            return object?.value(forKeyPath: "lineHeight") as! CGFloat
        }
    }
    var textColor: NSColor? {
        didSet {
            object?.setValue(textColor?.mscolor, forKey: "textColor")
        }
    }
    var characterSpacing: CGFloat {
        set(newValue) {
            object?.setValue(newValue, forKey: "characterSpacing")
        }
        get {
            return object?.value(forKeyPath: "characterSpacing") as! CGFloat
        }
    }
    
    func changeTextColor(color: NSColor)  {
        let selector = NSSelectorFromString("changeTextColorTo:")
        _ = object?.perform(selector, with: color)
    }
}

class DJLayer {
    private let sketchLayer: NSObject
    let exportOptions: DJExportOptions
    private lazy var layers: NSArray? = {
        guard let layers = sketchLayer.value(forKeyPath: "layers") as? NSArray else {
            return nil
        }
        return layers
    }()
    var radius: CGFloat {
        var value: CGFloat = 0
        if let first = layers?.firstObject as? NSObject,
            type(of: first).typeName == DJRectangleShape.className {
            value = first.value(forKeyPath: "fixedRadius") as? CGFloat ?? 0
        }
        return value
    }
    var rect: NSRect? {
        guard let rect = sketchLayer.value(forKeyPath: "absoluteRect.rect") as? CGRect else {
            return nil
        }
        return rect
    }
    var isVisible: Bool {
        return sketchLayer.value(forKeyPath: "isVisible") as! Bool
    }
    var isLock: Bool {
        return sketchLayer.value(forKeyPath: "isLock") as! Bool
    }
    lazy var parentGroup: NSObject? = {
        return sketchLayer.value(forKeyPath: "parentGroup") as? NSObject
    }()
    
    let style: DJStyle
    init(layer: NSObject) {
        sketchLayer = layer
        style = DJStyle(layer.value(forKeyPath: "style") as! NSObject)
        exportOptions = DJExportOptions(layer.value(forKeyPath: "exportOptions") as? NSObject)
    }
    
    func removeLayer() {
        DJLayer.removeLayer(sketchLayer)
    }
    
    class func removeLayer(_ layer: NSObject) {
        guard let container = layer.value(forKeyPath: "parentGroup") as? NSObjectProtocol else { return }
        let selector = NSSelectorFromString("removeLayer")
        container.perform(selector, with: layer)
    }
}

//MARK: Shape
final class DJRectangleShape: DJSketchObjectProtocol {
    static var className: String {
        return "MSRectangleShape"
    }
    var object: AnyObject?
    init(rect: NSRect = .init(x: 0, y: 0, width: 100, height: 100)) {
        let clazz = NSClassFromString(DJRectangleShape.className) as AnyObject
        let cls = clazz as! NSObjectProtocol
        object = DJSketchPluginHelper.convientInitializer(className: cls,
                                                          initSelector: "initWithFrame:",
                                                          with: rect)
    }
}

