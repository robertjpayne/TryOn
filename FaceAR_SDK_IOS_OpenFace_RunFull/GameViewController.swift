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


//TODO:

//A) Get a scn file with actual black glasses and clear lenses.
//B) Add head model and use as a mask, good info here @20:48 https://www.youtube.com/watch?v=0iAvcGsbFec

class GameViewController: UIViewController {
    
    @IBOutlet weak var scnView: SCNView!
    
    var ship = SCNNode()
    
    var animationInterval = 0.05
    
    enum Glasses {
        case purple
        case classyRims
    }
    var currentGlasses:Glasses = .purple

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        var fileName = ""
        switch currentGlasses {
        case .purple:
            fileName = "Glasses"
        default:
            fileName = "Glasses5"
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

        var s:Double = 0
        //Tweaks
        switch currentGlasses {
        case .purple:
            s = 14
        case .classyRims:
            s = 0.05
        }
        self.ship.scale = SCNVector3(s,s,s)

    }
    
    ///INTERVAL ACTIONS:::::::::::::::
    func animateOnInterval(){
        UIView.animate(withDuration: animationInterval, animations: {
            self.updateEuler()
            self.pinGlassesToNose()
//            self.updateCentralPosition()
        })
        
//        displayNumberLabels()
    }
    
    func displayNumberLabels() {
        
        for i in 0 ... 67 {
            guard let pointX = UserDefaults.standard.object(forKey: "\(i)x") as? NSNumber,
                let pointY = UserDefaults.standard.object(forKey: "\(i)y") as? NSNumber else {continue}
            
            let point = CGPoint(x: pointX.doubleValue, y: pointY.doubleValue)
            
            if let oldViewToRemove = self.view.viewWithTag(i + 1) {
                oldViewToRemove.removeFromSuperview()
            }
            let label = UILabel(frame: CGRect(origin: point, size: CGSize(width: 50, height: 50)))
            label.text = "\(i)"
            label.tag = i + 1
            view.addSubview(label)
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
            
            //Tweaks
            switch currentGlasses {
            case .purple:
                _yaw = _yaw - 0.2
            case .classyRims:
                _pitch += 300
            }
            
            self.ship.eulerAngles = SCNVector3(_pitch, _yaw, _roll)
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
        case .purple:
            _y -= 50
        case .classyRims:
            break
        }
        
        //Fudge and flips:
        _x /= 8
        _y /= -8
        _z /= -8
//        print("pinning to nose: x:\(_x) y:\(_y) z:\(_z)")
        self.ship.position = SCNVector3(_x, _y, _z)

    }
    
    func updateCentralPosition() {
        if let xPos = UserDefaults.standard.object(forKey: "xPos") as? NSNumber,
            let yPos = UserDefaults.standard.object(forKey: "yPos") as? NSNumber,
            let zPos = UserDefaults.standard.object(forKey: "zPos") as? NSNumber {
            let _x = Float(xPos)/4
            let _y = (-Float(yPos) + 75)/4
            let _z = -Float(zPos)/6

            print("central Postion: x:\(_x) y:\(_y) z:\(_z)")
            self.ship.position = SCNVector3(_x, _y, _z)
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
