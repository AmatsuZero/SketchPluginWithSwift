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
    var className: String { get }
    var object: AnyObject? { set get }
    func new(selector: String, with: Any?) -> AnyObject?
}

extension DJSketchObjectProtocol {
    func new(selector: String = "init", with: Any? = nil) -> AnyObject? {
        let clazz = NSClassFromString(className) as AnyObject
        let cls = clazz as! NSObjectProtocol
        return DJSketchPluginHelper.convientInitializer(className: cls, initSelector: selector, with: with)
    }
}

//MARK: Layer
final class DJLayerGroup: DJSketchObjectProtocol {
    var className: String {
        return "MSLayerGroup"
    }
    lazy var object: AnyObject? = {
        return new()
    }()
}

final class DJShapeGroup: DJSketchObjectProtocol {
    var className: String { return "MSShapeGroup" }
    var object: AnyObject?
    init(rect: NSRect = .init(x: 0, y: 0, width: 100, height: 100), shape: DJRectangleShape) {
        let clazz = NSClassFromString("MSShapeGroup") as AnyObject
        let cls = clazz as! NSObjectProtocol
        let selector = NSSelectorFromString("shapeWithPath:")
        object = cls.perform(selector, with: shape.object)?.takeUnretainedValue()
    }
}

final class DJTextLayer: DJSketchObjectProtocol {
    var className: String {
        return "MSLayerGroup"
    }
    lazy var object: AnyObject? = {
        return new()
    }()
}

final class DJLayer {
    private let sketchLayer: NSObject
    private lazy var layers: NSArray? = {
        guard let layers = sketchLayer.value(forKeyPath: "layers") as? NSArray else {
            return nil
        }
        return layers
    }()
    var radius: CGFloat {
        var value: CGFloat = 0
        if let first = layers?.firstObject as? NSObject,
            type(of: first).typeName == "MSRectangleShape" {
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
    let style: DJStyle
    init(layer: NSObject) {
        sketchLayer = layer
        style = DJStyle(layer.value(forKeyPath: "style") as! NSObject)
    }
    
    func removeLayer() {
        guard let container = sketchLayer.value(forKeyPath: "parentGroup") as? NSObjectProtocol else { return }
        let selector = NSSelectorFromString("removeLayer")
        container.perform(selector, with: sketchLayer)
    }
}

//MARK: Shape
final class DJRectangleShape: DJSketchObjectProtocol {
    var className: String {
        return "MSRectangleShape"
    }
    var object: AnyObject?
    init(rect: NSRect = .init(x: 0, y: 0, width: 100, height: 100)) {
        let clazz = NSClassFromString("MSRectangleShape") as AnyObject
        let cls = clazz as! NSObjectProtocol
        object = DJSketchPluginHelper.convientInitializer(className: cls,
                                                          initSelector: "initWithFrame:",
                                                          with: rect)
    }
}

