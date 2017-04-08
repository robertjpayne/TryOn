//
//  Utilities+Extensions.swift
//  TryOn
//
//  Created by Chris Dunaetz on 4/7/17.
//  Copyright © 2017 Chris Dunaetz. All rights reserved.
//

import Foundation

func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
