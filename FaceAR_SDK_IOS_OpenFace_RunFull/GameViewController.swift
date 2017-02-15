//
//  GameViewController.swift
//  MyFirstGame
//
//  Created by Chris Dunaetz on 2/14/17.
//  Copyright © 2017 Chris Dunaetz. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var scnView: SCNView!
    
    var ship = SCNNode()
    
    var animationInterval = 0.03

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/Glasses.scn")!
        
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
        
        // retrieve the ship node
        ship = scene.rootNode.childNode(withName: "glasses", recursively: true)!
        
        // animate the 3d object
//        ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
//        ship.runAction(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1))
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.clear
        
        // add a tap gesture recognizer
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        scnView.addGestureRecognizer(tapGesture)
        
        
        let _ = Timer.scheduledTimer(timeInterval: animationInterval, target: self, selector: #selector(animateOnInterval), userInfo: nil, repeats: true)

        let s = 17
        self.ship.scale = SCNVector3(s,s,s)
    }
    
    ///INTERVAL ACTIONS:::::::::::::::
    func animateOnInterval(){
        UIView.animate(withDuration: animationInterval, animations: {
            self.updateEuler()
            self.updatePosition()
        })
        
        if let pointX = UserDefaults.standard.object(forKey: "33x") as? NSNumber,
            let pointY = UserDefaults.standard.object(forKey: "33y") as? NSNumber {
            let point = CGPoint(x: pointX.doubleValue, y: pointY.doubleValue)
            print(point)
        }
    }
    
    func updateEuler(){
        if let pitch = UserDefaults.standard.object(forKey: "pitch") as? NSNumber,
            let yaw = UserDefaults.standard.object(forKey: "yaw") as? NSNumber,
            let roll = UserDefaults.standard.object(forKey: "roll") as? NSNumber {
            var _pitch = Float(pitch)//Float(pitch)/57
            var _yaw = -Float(yaw)
            var _roll = -Float(roll)
//            print(pitch)
            
            //Adjust yaw for wonky glasses:
            _yaw = _yaw - 0.2
            
            self.ship.eulerAngles = SCNVector3(_pitch, _yaw, _roll)
        }
        
    
    }
    func updatePosition() {
        if let xPos = UserDefaults.standard.object(forKey: "xPos") as? NSNumber,
            let yPos = UserDefaults.standard.object(forKey: "yPos") as? NSNumber,
            let zPos = UserDefaults.standard.object(forKey: "zPos") as? NSNumber {
            let _xPos = Float(xPos)/4
            let _yPos = -Float(yPos)/4 + 20
            let _zPos = -Float(zPos)/6
//            print(zPos)
            self.ship.position = SCNVector3(_xPos, _yPos, _zPos)
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
