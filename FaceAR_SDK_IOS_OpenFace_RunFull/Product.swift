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
    var title:String!
    fileprivate var sceneTitle = ""
    var scene:SCNScene? {
        return SCNScene(named: "art.scnassets/\(sceneTitle).scn")
    }
    var detailScene:SCNScene? {
        return SCNScene(named: "art.scnassets/detail\(sceneTitle).scn")
    }
    var matrix:Matrix?
    
    required init(sceneTitle:String, matrix:Matrix?) {
        self.sceneTitle = sceneTitle
        self.title = sceneTitle
        self.matrix = matrix
    }
}
