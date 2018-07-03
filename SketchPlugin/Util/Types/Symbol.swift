//
//  Symbol.swift
//  SketchPlugin
//
//  Created by Jiang,Zhenhua on 2018/7/2.
//  Copyright © 2018年 Daubert. All rights reserved.
//

import Foundation

final class DJSymbolMaster: DJLayer {
    var className: String {
        return "MSSymbolMaster"
    }
    var object: AnyObject?
    var symbolObjectID: String? {
        return object?.value(forKeyPath: "objectID") as? String
    }
    var children: NSArray? {
        return object?.value(forKeyPath: "children") as? NSArray
    }
    
    init(_ msobject: AnyObject) {
        object = msobject
        super.init(layer: msobject as! NSObject)
    }
    
    func replicate() -> DJLayer? {
        guard let tmpSymbolLayers = children else { return nil }
        let tmpSymbol = object?.perform(NSSelectorFromString("duplicate")).takeUnretainedValue()
        let tmpGroup = tmpSymbol?.perform(NSSelectorFromString("detachByReplacingWithGroup")).takeUnretainedValue()
        _ = tmpGroup?.perform(NSSelectorFromString("resizeToFitChildrenWithOption:"), with: 0)
        defer {
            DJLayer.removeLayer(tmpGroup as! NSObject)
        }
        var overrides = object?.value(forKeyPath: "overrides") as? NSDictionary
        if overrides != nil {
            overrides = overrides?.object(forKey: 0) as? NSDictionary
        }
        for case let tmpSymbolLayer as NSObject in tmpSymbolLayers
            where type(of: tmpSymbolLayer).typeName == DJSymbolInstance.className {
                let symbolMasterObjID = tmpSymbolLayer.value(forKeyPath: "objectID") as! String
                if let overrides = overrides,
                    overrides[symbolMasterObjID] != nil,
                    let symbolID = (overrides[symbolMasterObjID] as AnyObject).value(forKeyPath: "symbolID") as? String {
                    if let changeSymbol = DJSketchPlugin.shared.parser.sharedSymbol(symbolID) {
                        tmpSymbolLayer.perform(NSSelectorFromString("changeInstanceToSymbol:"), with: changeSymbol)
                        return DJLayer(layer: tmpSymbolLayer)
                    }
                }
        }
        return nil
    }
}

final class DJSymbolInstance: DJSketchObjectProtocol {
    static var className: String {
        return "MSSymbolInstance"
    }
    var overrides: NSDictionary? {
        return object?.value(forKeyPath: "overrides") as? NSDictionary
    }
    var object: AnyObject?
    let symbolMaster: DJSymbolMaster?
    
    init(_ symbolinstance: AnyObject?) {
        object = symbolinstance
        let master = object?.value(forKeyPath: "symbolMaster") as AnyObject
        symbolMaster = DJSymbolMaster(master)
    }
}
