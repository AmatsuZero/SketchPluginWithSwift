//
//  Parser.swift
//  SketchPlugin
//
//  Created by Jiang,Zhenhua on 2018/6/30.
//  Copyright © 2018年 Daubert. All rights reserved.
//

import Foundation

class DJSketchParser {
    private let document: NSDocument
    private let sharedStyles: DJSharedStyleContainer
    private var documentData: NSObject? {
        return document.value(forKeyPath: "documentData") as? NSObject
    }
    
    init(document: NSDocument) {
        self.document = document
        let container = document.value(forKeyPath: "documentData.layerStyles") as! NSObject
        sharedStyles = DJSharedStyleContainer(container)
    }
    
    func allSymbols() -> NSArray? {
        return documentData?.perform(NSSelectorFromString("allSymbols")).takeUnretainedValue() as? NSArray
    }
    
    func sharedSymbol(_ symbolID: String) -> NSObject? {
        let predicate = NSPredicate(format: "(symbolID != NULL) && (symbolID == %@)", symbolID)
        return allSymbols()?.filtered(using: predicate).first as? NSObject
    }
}
