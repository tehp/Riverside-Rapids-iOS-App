//
//  BSBlock.swift
//  Rapids
//
//  Created by Noah on 2016-02-22.
//  Copyright © 2016 Riverside Secondary School. All rights reserved.
//

import Foundation

class BSBlock {
    
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
    }
    
}