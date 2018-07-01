//
//  SketchClasses.swift
//  SketchPlugin
//
//  Created by Jiang,Zhenhua on 2018/6/30.
//  Copyright © 2018年 Daubert. All rights reserved.
//

import Foundation
import SwiftyJSON

//MARK: Layer
final class DJLayerGroup {
    private let clazz = NSClassFromString("MSLayerGroup") as AnyObject
    @objc func new() -> AnyObject? {
        guard let cls = clazz as? NSObjectProtocol else {
            return nil
        }
        return DJSketchPluginHelper.convientInitializer(className: cls)
    }
}

final class DJShapeGroup {
    private let clazz = NSClassFromString("MSShapeGroup") as AnyObject
    func new(rect: NSRect = .init(x: 0, y: 0, width: 100, height: 100),
             shape: DJRectangleShape) -> AnyObject? {
        guard let cls = clazz as? NSObjectProtocol else {
            return nil
        }
        let selector = NSSelectorFromString("shapeWithPath:")
        return cls.perform(selector, with: shape.new(rect: rect))?
            .takeUnretainedValue()
    }
}

final class DJTextLayer {
    private let clazz = NSClassFromString("MSTextLayer") as AnyObject
    @objc func new() -> AnyObject? {
        guard let cls = clazz as? NSObjectProtocol else {
            return nil
        }
        return DJSketchPluginHelper.convientInitializer(className: cls)
    }
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
        style = DJStyle(style: layer.value(forKeyPath: "style") as! NSObject)
    }
    
    func removeLayer() {
        guard let container = sketchLayer.value(forKeyPath: "parentGroup") as? NSObjectProtocol else { return }
        let selector = NSSelectorFromString("removeLayer")
        container.perform(selector, with: sketchLayer)
    }
}

//MARK: Shape
final class DJRectangleShape {
    private let clazz = NSClassFromString("MSRectangleShape") as AnyObject
    @objc func new(rect: NSRect = .init(x: 0, y: 0, width: 100, height: 100)) -> AnyObject? {
        guard let cls = clazz as? NSObjectProtocol else {
            return nil
        }
        return DJSketchPluginHelper.convientInitializer(className: cls,
                                                        initSelector: "initWithFrame:",
                                                        with: rect)
    }
}

