//
//  ProductSceneViewController.swift
//  TryOn
//
//  Created by Chris Dunaetz on 4/8/17.
//  Copyright © 2017 Chris Dunaetz. All rights reserved.
//

import UIKit
import SceneKit

class ProductSceneViewController: UIViewController {

    @IBOutlet weak var scnView: SCNView!

    var productNode = SCNNode()
    
    var animationInterval = 0.05
    var animationTimer: Timer?
    enum Glasses {
        case purple
        case classyRims
        case topanga
    }
    var currentGlasses:Glasses = .classyRims
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupMainScene()
    }
    
    //MARK: Setup
    
    func setupMainScene(){
        // create a new scene
        var fileName = ""
        switch currentGlasses {
        case .purple:
            fileName = "Glasses"
        case .classyRims:
            fileName = "ClassyGlassesClearLenses"//"ClassyGlasses"
        case .topanga:
            fileName = "Topanga"
        }
        let scene = SCNScene(named: "art.scnassets/\(fileName).scn")!
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the productNode node
        //        productNode = scene.rootNode.childNode(withName: "instance_0", recursively: true)!
        productNode = scene.rootNode.childNodes.first ??  SCNNode()
        
        
        // animate the 3d object
        //        productNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        //        productNode.runAction(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1))
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        //        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        //        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.clear
        
        // add a tap gesture recognizer
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        //        scnView.addGestureRecognizer(tapGesture)
        
        
        let _ = Timer.scheduledTimer(timeInterval: animationInterval, target: self, selector: #selector(animateOnInterval), userInfo: nil, repeats: true)

    }
    
    //MARK: Switching Products
    
    func updateProduct(){
        
    }
    
    //MARK: Animation
    
    func animateOnInterval(){
        UIView.animate(withDuration: animationInterval, animations: {
            self.updateEuler()
            self.pinGlassesToNose()
            
            //This can be placed in animateOnInterval() if you want to test it out with the slider:
            self.updateScale()
        })
        
        //        displayNumberLabels()
    }
    
    func updateScale() {
        var s:Double = 0
        //Tweaks
        switch currentGlasses {
        case .purple:
            s = 14
        case .classyRims:
            s = 6.6
        case .topanga:
            s = 14
        }
        
        productNode.scale = SCNVector3(s,s,s)
    }
    
    func updateEuler(){
        if let pitch = UserDefaults.standard.object(forKey: "pitch") as? NSNumber,
            let yaw = UserDefaults.standard.object(forKey: "yaw") as? NSNumber,
            let roll = UserDefaults.standard.object(forKey: "roll") as? NSNumber {
            var _pitch = Float(pitch)//Float(pitch)/57
            var _yaw = -Float(yaw)
            var _roll = -Float(roll)
            //            print(pitch)
            
            //Tweaks
            switch currentGlasses {
            case .purple, .topanga:
                _yaw = _yaw - 0.2
            case .classyRims:
                _pitch += 300
            }
            
            productNode.eulerAngles = SCNVector3(_pitch, _yaw, _roll)
        }
        
        
    }
    
    func pinGlassesToNose(){
        let i = 27 //Point on Nose
        guard let pointX = UserDefaults.standard.object(forKey: "\(i)x") as? NSNumber,
            let pointY = UserDefaults.standard.object(forKey: "\(i)y") as? NSNumber,
            let zPos = UserDefaults.standard.object(forKey: "zPos") as? NSNumber else {return}
        var _x = pointX.doubleValue
        var _y = pointY.doubleValue
        var _z = zPos.doubleValue
        
        //        print("x:\(pointX) y:\(pointY) z:\(zPos)")
        let screenWidth = Double(480)
        let screenHeight = Double(640)
        
        _x -= screenWidth/2
        _y -= screenHeight/2
        //        print("x:\(_x) y:\(_y) z:\(_z)")
        
        //Tweaks
        switch currentGlasses {
        case .purple, .topanga:
            _y -= 50
            _z += 92
        case .classyRims:
            _y += 38
            _z += 200
        }
        
        //Fudge and flips:
        _x /= 8
        _y /= -8
        _z /= -8
        //        print("pinning to nose: x:\(_x) y:\(_y) z:\(_z)")
        //        _x = 200
        //        _y = 0
        
        productNode.position = SCNVector3(_x, _y, _z)
        
    }
    
    func updateCentralPosition() {
        if let xPos = UserDefaults.standard.object(forKey: "xPos") as? NSNumber,
            let yPos = UserDefaults.standard.object(forKey: "yPos") as? NSNumber,
            let zPos = UserDefaults.standard.object(forKey: "zPos") as? NSNumber {
            let _x = Float(xPos)/4
            let _y = (-Float(yPos) + 75)/4
            let _z = -Float(zPos)/6
            
            //            print("central Postion: x:\(_x) y:\(_y) z:\(_z)")
            productNode.position = SCNVector3(_x, _y, _z)
        }
    }


}
