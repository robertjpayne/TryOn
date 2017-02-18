//
//  Product.swift
//  FaceAR_SDK_IOS_OpenFace_RunFull
//
//  Created by Chris Dunaetz on 2/18/17.
//  Copyright © 2017 Keegan Ren. All rights reserved.
//

import Foundation
import SceneKit

class Axes {
    required init(x:Float, y:Float, z:Float){
        self.x = x
        self.y = y
        self.z = z
    }
    var x:Float
    var y:Float
    var z:Float
}

class Matrix {
    required init(positionAdjustment:Axes, rotationAdjustment:Axes, scale:Axes) {
        self.positionAdjustment = positionAdjustment
        self.rotationAdjustment = rotationAdjustment
        self.scale = scale
    }
    var positionAdjustment:Axes
    var rotationAdjustment:Axes
    var scale:Axes
    
}

class Product {
    var scene:SCNScene!
    var matrix:Matrix!
    
    required init(sceneTitle:String, matrix:Matrix) {
        self.scene = SCNScene(named: "art.scnassets/\(sceneTitle).scn")!
        self.matrix = matrix
    }
}
