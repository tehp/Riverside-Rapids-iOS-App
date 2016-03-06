//
//  BSBlock.swift
//  Rapids
//
//  Created by Noah on 2016-02-22.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class BSBlock: NSObject, NSCoding {
    
    struct PropertyKey {
        static let blockKey = "block"
        static let startHKey = "startH"
        static let startMKey = "startM"
        static let endHKey = "endH"
        static let endMKey = "endM"
    }
    
    var block: Int
    var startH: Int
    var startM: Int
    var endH: Int
    var endM: Int
    
    init(block: Int, startH: Int, startM: Int, endH: Int, endM: Int) {
        self.block = block
        self.startH = startH
        self.startM = startM
        self.endH = endH
        self.endM = endM
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let block = aDecoder.decodeIntegerForKey(PropertyKey.blockKey)
        let startH = aDecoder.decodeIntegerForKey(PropertyKey.startHKey)
        let startM = aDecoder.decodeIntegerForKey(PropertyKey.startMKey)
        let endH = aDecoder.decodeIntegerForKey(PropertyKey.endHKey)
        let endM = aDecoder.decodeIntegerForKey(PropertyKey.endMKey)
        
        self.init(block: block, startH: startH, startM: startM, endH: endH, endM: endM)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(block, forKey: PropertyKey.blockKey)
        aCoder.encodeInteger(startH, forKey: PropertyKey.startHKey)
        aCoder.encodeInteger(startM, forKey: PropertyKey.startMKey)
        aCoder.encodeInteger(endH, forKey: PropertyKey.endHKey)
        aCoder.encodeInteger(endM, forKey: PropertyKey.endMKey)
    }
    
}