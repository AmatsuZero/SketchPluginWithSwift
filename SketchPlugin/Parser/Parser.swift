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
    
    init(document: NSDocument) {
        self.document = document
        let container = document.value(forKeyPath: "documentData.layerStyles") as! NSObject
        sharedStyles = DJSharedStyleContainer(container)
    }
}
